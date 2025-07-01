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
  'socket' => 's'
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
  filename_table = Array.new(rows) { Array.new(columns) }
  max_filename_width = filenames.map(&:length).max

  filenames.each_with_index do |name, index|
    col, row = index.divmod(rows)

    filename_table[row][col] = name.ljust(max_filename_width + 1)
  end

  filename_table
end

def file_infos_for_long_format(filenames)
  file_infos = filenames.map { |path| [path, File.lstat(path)] }

  max_widths = calc_max_widths(file_infos)
  file_infos.map do |path, file_info|
    [
      format_file_mode(file_info),
      file_info.nlink.to_s.rjust(max_widths[:link]),
      Etc.getpwuid(file_info.uid).name.ljust(max_widths[:user]),
      Etc.getgrgid(file_info.gid).name.ljust(max_widths[:group]),
      "#{file_info.size.to_s.rjust(max_widths[:size])} ",
      file_info.mtime.strftime('%-m月 %e %H:%M'),
      if format_file_mode(file_info).include?('l')
        "#{path} -> #{File.readlink(path)}"
      else
        path
      end
    ].join(' ')
  end
end

def format_file_mode(file_info)
  file_type_and_permission = []

  file_type = file_info.ftype
  file_type_and_permission << FILE_TYPE[file_type]

  file_permission = file_info.mode.to_s(8).split('')
  file_permission = file_permission[-3..].map(&:to_i)
  file_permission = file_permission.map { |val| FILE_PERMISSION[val] }.compact.join
  file_type_and_permission << file_permission

  file_type_and_permission.join
end

def calc_max_widths(file_infos)
  {
    link: file_infos.map { |_, file_info| file_info.nlink }.max.to_s.length,
    size: file_infos.map { |_, file_info| file_info.size }.max.to_s.length,
    user: file_infos.map { |_, file_info| Etc.getpwuid(file_info.uid).name }.max_by(&:length).length,
    group: file_infos.map { |_, file_info| Etc.getgrgid(file_info.gid).name }.max_by(&:length).length
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
  long_format_lines = file_infos_for_long_format(filenames)
  puts long_format_lines
else
  filename_lines = format_filenames_table(filenames, COLUMNS)
  output_lines(filename_lines)
end
