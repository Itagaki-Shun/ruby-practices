#! /usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:characters] = true }
end.parse!

def file_statistics(read_file)
  lines = read_file.lines.count
  words = read_file.split
  words_count = words.length
  characters = read_file.bytesize

  result = ["  #{lines}  ", words_count, characters].join(' ')
end

if ARGV.empty?
  read_file = $stdin.read
  puts file_statistics(read_file)
else
  file = File.open(ARGV[0])
  read_file = File.read(file)
  puts "#{file_statistics(read_file)} #{file.path}"
end
