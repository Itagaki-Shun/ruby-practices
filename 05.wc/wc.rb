#! /usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:characters] = true }
end.parse!

def file_statistics(read_file, options, total_statistics = nil, is_total: false)
  if is_total
    sum_totals = total_statistics.transpose.map(&:sum)
    format_statistics(*sum_totals, options).join
  else
    lines = read_file.lines.count
    words = read_file.split.count
    characters = read_file.bytesize
    total_statistics << [lines, words, characters]
    format_statistics(lines, words, characters, options).join
  end
end

def format_statistics(lines, words, characters, options)
  results = []
  widths = column_widths(options)
  results << lines if options[:lines] || options.empty?
  results << words if options[:words] || options.empty?
  results << characters if options[:characters] || options.empty?
  results.map.with_index { |value, index| value.to_s.rjust(widths[index]) }
end

def column_widths(options)
  if ARGV.empty?
    if options.values.count(true) == 1
      [0, 0, 0]
    else
      [7, 8, 8]
    end
  elsif options.values.count(true) == 1
    [0, 0, 0]
  else
    [4, 5, 5]
  end
end

case ARGV.length
when 0
  read_file = $stdin.read
  puts file_statistics(read_file, options, [])
when 1
  file = File.open(ARGV[0])
  read_file = File.read(file)
  puts "#{file_statistics(read_file, options, [])} #{file.path}"
else
  statistics = []
  ARGV.each_with_index do |filename, index|
    file = File.open(filename)
    read_file = File.read(file)
    puts "#{file_statistics(read_file, options, statistics)} #{file.path}"
    puts "#{file_statistics(nil, options, statistics, is_total: true)} 合計" if index == ARGV.length - 1
  end
end
