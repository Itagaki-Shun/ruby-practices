#!/usr/bin/env ruby

path = "/home/itagaki_syun/ruby-practices/04.ls"
file = Dir.entries(path)

file.delete_if { |str| str.start_with?('.') }

file = file.sort_by(&:downcase)

columns = 3
rows = (file.size.to_f / columns).ceil
transformation_file = Array.new(rows) { Array.new(columns) }
file_name_length = file.max_by{ |str| str.to_s.length}
space =  file_name_length.length

file.each_with_index do |name, index|
  row = index % rows
  col = index / rows
  transformation_file[row][col] = name.ljust(space + 1)
end

transformation_file.each do |row|
  puts row.compact.join
end
