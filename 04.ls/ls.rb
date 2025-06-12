#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-a') { options[:all] = true }
  opts.on('-r') { options[:reverse] = true }
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

# 出力を行うメソッド
def output_file(filenames)
  filenames.each do |row|
    puts row.compact.join
  end
end

filenames = transformation_file(filenames, COLUMNS)
output_file(filenames)
