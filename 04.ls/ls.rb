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

# ファイルやディレクトリを指定した形に変換するメソッド
def transformation_file(filenames, columns)
  rows = (filenames.size.to_f / columns).ceil
  transformation_filenames = Array.new(rows) { Array.new(columns) }
  file_name_length = filenames.max_by { |name| name.to_s.length }.length

  filenames.each_with_index do |name, index|
    col, row = index.divmod(rows)

    transformation_filenames[row][col] = name.ljust(file_name_length + 1) if col != columns
  end

  transformation_filenames
end

# ファイルやディレクトリの情報を取得するメソッド
def stat_file(filenames)
  filenames.map do |path|
    stat = File::Stat.new(path)
    [
      format_permission(stat),
      stat.nlink,
      Etc.getpwuid(stat.uid).name,
      Etc.getpwuid(stat.gid).name,
      "#{stat.size} ",
      stat.mtime.strftime('%-m月 %e %H:%M'),
      path
    ].join(' ')
  end
end

def format_permission(stat)
  file_type_and_permission = []

  file_type = stat.ftype
  file_type_and_permission << FILE_TYPE[file_type]

  file_permission = stat.mode.to_s(8).split('')
  file_permission = file_permission[-3..].map(&:to_i)
  file_permission = file_permission.map { |val| FILE_PERMISSION[val] }.compact.join
  file_type_and_permission << file_permission

  file_type_and_permission.join
end

# 出力を行うメソッド
def output_file(filenames, options)
  if options[:long_format]
    puts filenames
  else
    filenames.each do |row|
      puts row.compact.join
    end
  end
end

filenames = if options[:long_format]
              # OS標準の-lコマンドにブロックサイズを合わせる
              total_blocks = filenames.sum { |name| File::Stat.new(name).blocks / 2 }
              puts "合計 #{total_blocks}"
              stat_file(filenames)
            else
              transformation_file(filenames, COLUMNS)
            end
output_file(filenames, options)
