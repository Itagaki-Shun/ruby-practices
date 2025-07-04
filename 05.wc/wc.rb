#! /usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:characters] = true }
end.parse!

def file_statistics(read_file, options)
  lines = read_file.lines.count
  words = read_file.split
  words_count = words.length
  characters = read_file.bytesize

  result = []
  result << lines.to_s.rjust(column_widths[:lines]) if options[:lines] || options.empty?
  result << words_count.to_s.rjust(column_widths[:words]) if options[:words] || options.empty?
  result << characters.to_s.rjust(column_widths[:characters]) if options[:characters] || options.empty?
  result.join
end

def column_widths
  if ARGV.empty?
    { lines: 7, words: 8, characters: 8 }
  else
    { lines: 4, words: 5, characters: 5 }
  end
end

if ARGV.empty?
  read_file = $stdin.read
  puts file_statistics(read_file, options)
else
  file = File.open(ARGV[0])
  read_file = File.read(file)
  puts "#{file_statistics(read_file, options)} #{file.path}"
end
