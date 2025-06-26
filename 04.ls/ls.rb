#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

FILE_TYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket"' => 's'
}.freeze
FILE_PERMISSION = {
  0 => '---',
  1 => '--x',
  2 => '-w-',
  3 => '-wx',
  4 => 'r--',
  5 => 'r-x',
  6 => 'rw-',
  7 => 'rwx'
}.freeze

options = {}
OptionParser.new do |opts|
  opts.on('-a') { options[:all] = true }
  opts.on('-r') { options[:reverse] = true }
  opts.on('-l') { options[:long_format] = true }
end.parse!

flags = options[:all] ? File::FNM_DOTMATCH : 0
filenames = Dir.glob('*', flags)
filenames.reverse! if options[:reverse]

COLUMNS = 3

def format_filenames_table(filenames, columns)
  rows = (filenames.size.to_f / columns).ceil
  transformation_filenames = Array.new(rows) { Array.new(columns) }
  file_name_length = filenames.max_by { |name| name.to_s.length }.length

  filenames.each_with_index do |name, index|
    col, row = index.divmod(rows)

    transformation_filenames[row][col] = name.ljust(file_name_length + 1) if col != columns
  end

  transformation_filenames
end

def file_infos_for_long_format(filenames)
  stats = filenames.map { |path| [path, File.lstat(path)] }

  widths = calc_max_widths(stats)
  stats.map do |path, stat|
    [
      format_file_mode(stat),
      stat.nlink.to_s.rjust(widths[:link]),
      Etc.getpwuid(stat.uid).name.to_s.ljust(widths[:user]),
      Etc.getgrgid(stat.gid).name.to_s.ljust(widths[:group]),
      "#{stat.size.to_s.rjust(widths[:size])} ",
      stat.mtime.strftime('%-m月 %e %H:%M'),
      if format_file_mode(stat).include?('l')
        "#{path} -> #{File.readlink(path)}"
      else
        path
      end
    ].join(' ')
  end
end

def format_file_mode(stat)
  file_type_and_permission = []

  file_type = stat.ftype
  file_type_and_permission << FILE_TYPE[file_type]

  file_permission = stat.mode.to_s(8).split('')
  file_permission = file_permission[-3..].map(&:to_i)
  file_permission = file_permission.map { |val| FILE_PERMISSION[val] }.compact.join
  file_type_and_permission << file_permission

  file_type_and_permission.join
end

def calc_max_widths(stats)
  {
    link: stats.map { |_, stat| stat.nlink }.max.to_s.length,
    size: stats.map { |_, stat| stat.size }.max.to_s.length,
    user: stats.map { |_, stat| Etc.getpwuid(stat.uid).name }.max_by(&:length).length,
    group: stats.map { |_, stat| Etc.getgrgid(stat.gid).name }.max_by(&:length).length
  }
end

def output_lines(lines)
  lines.each do |row|
    puts row.compact.join
  end
end

if options[:long_format]
  # OS標準の-lコマンドにブロックサイズを合わせる
  total_blocks = filenames.sum { |name| File.lstat(name).blocks / 2 }
  puts "合計 #{total_blocks}"
  stat_lines = file_infos_for_long_format(filenames)
  puts stat_lines
else
  filenames = format_filenames_table(filenames, COLUMNS)
  output_lines(filenames)
end
