#!/usr/bin/env ruby

# frozen_string_literal: true

file = Dir.glob('*')
COLUMNS = 3

# ファイルやディレクトリを指定した形に変換するメソッド
def transformation_file(file, columns)
  rows = (file.size.to_f / columns).ceil
  transformation_file = Array.new(rows) { Array.new(columns) }
  file_name_length = file.max_by { |name| name.to_s.length }

  file.each_with_index do |name, index|
    row = index % rows
    col = index / rows
    transformation_file[row][col] = name.ljust(file_name_length.length + 1) unless col == columns
  end

  transformation_file
end

# 出力を行うメソッド
def output_file(file)
  file.each do |row|
    puts row.compact.join
  end
end

file = transformation_file(file, COLUMNS)
output_file(file)
