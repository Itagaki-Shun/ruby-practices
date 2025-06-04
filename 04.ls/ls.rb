#!/usr/bin/env ruby

# frozen_string_literal: true

case ARGV[0]
when nil
  file = Dir.glob('*')
when '-a'
  file = Dir.entries('.')
end
COLUMNS = 3

# ソートするメソッド
def sort_files(files)

end

# ファイルやディレクトリを指定した形に変換するメソッド
def transformation_file(file, columns)
  rows = (file.size.to_f / columns).ceil
  transformation_file = Array.new(rows) { Array.new(columns) }
  file_name_length = file.max_by { |name| name.to_s.length }.length

  file.each_with_index do |name, index|
    col, row = index.divmod(rows)

    transformation_file[row][col] = name.ljust(file_name_length + 1) if col != columns
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
