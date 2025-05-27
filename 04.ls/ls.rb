#!/usr/bin/env ruby

# frozen_string_literal: true

file = Dir.glob('*')

# ファイルやディレクトリを指定した形で出力できるように変換し、出力する処理
def transformation_output_file(file)
  columns = 3
  rows = (file.size.to_f / columns).ceil
  transformation_file = Array.new(rows) { Array.new(columns) }
  file_name_length = file.max_by { |name| name.to_s.length }

  file.each_with_index do |name, index|
    row = index % rows
    col = index / rows
    transformation_file[row][col] = name.ljust(file_name_length.length + 1) unless col == columns
  end

  transformation_file.each do |row|
    puts row.compact.join
  end
end

transformation_output_file(file)
