#!/usr/bin/env ruby

# frozen_string_literal: true

file = Dir.glob('*')

# ファイルやディレクトリをアルファベット順にソートする処理（現プラクティスの対象ディレクトリでは不要）
def file_sort(file)
  file.reject { |str| str.start_with?('.') }.sort_by(&:downcase)
end

file = file_sort(file)

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
