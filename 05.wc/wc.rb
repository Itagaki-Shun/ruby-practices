#! /usr/bin/env ruby

file = File.open(ARGV[0])
read_file = File.read(file)

def file_statistics(read_file)
  lines = read_file.lines.count
  words = read_file.split
  words_count = words.length
  characters = read_file.bytesize

  result = ["  #{lines}  ", words_count, characters].join(' ')
end

puts "#{file_statistics(read_file)} #{file.path}"
