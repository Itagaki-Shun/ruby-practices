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
  if ARGV.empty?
    result << lines.to_s.rjust(7) if options[:lines] || options.empty?
    result << words_count.to_s.rjust(8) if options[:words] || options.empty?
    result << characters.to_s.rjust(8) if options[:characters] || options.empty?
  else
    result << lines.to_s.rjust(4) if options[:lines] || options.empty?
    result << words_count.to_s.rjust(5) if options[:words] || options.empty?
    result << characters.to_s.rjust(5) if options[:characters] || options.empty?
  end
  result.join
end

if ARGV.empty?
  read_file = $stdin.read
  puts file_statistics(read_file, options)
else
  file = File.open(ARGV[0])
  read_file = File.read(file)
  puts "#{file_statistics(read_file, options)} #{file.path}"
end
