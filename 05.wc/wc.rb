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

  format_statistics(lines, words_count, characters, options).join
end

def calc_file_statistics_totals(statistics_for_each_file, options)
  total_statistics = statistics_for_each_file.map do |str|
    str.strip.split.map(&:to_i)
  end
  sum_totals = total_statistics.transpose.map(&:sum)
  format_statistics(sum_totals[0], sum_totals[1], sum_totals[2], options).join
end

def format_statistics(lines, words_count, characters, options)
  result = []
  widths = column_widths(options)
  result << lines if options[:lines] || options.empty?
  result << words_count if options[:words] || options.empty?
  result << characters if options[:characters] || options.empty?
  result.map.with_index { |value, index| value.to_s.rjust(widths[index]) }
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
  puts file_statistics(read_file, options)
when 1
  file = File.open(ARGV[0])
  read_file = File.read(file)
  puts "#{file_statistics(read_file, options)} #{file.path}"
else
  statistics_for_each_file = []
  ARGV.each_with_index do |filenames, index|
    file = File.open(filenames)
    read_file = File.read(file)
    puts "#{file_statistics(read_file, options)} #{file.path}"
    statistics_for_each_file << file_statistics(read_file, options)
    puts "#{calc_file_statistics_totals(statistics_for_each_file, options)} 合計" if index == ARGV.length - 1
  end
end
