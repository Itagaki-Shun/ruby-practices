#!/usr/bin/env ruby

# frozen_string_literal: true

PATH = Dir.pwd
file = Dir.entries(PATH)

file = file.reject { |str| str.start_with?('.') }.sort_by(&:downcase)

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
