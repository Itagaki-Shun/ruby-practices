#! /usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:characters] = true }
end.parse!

def file_statistics(read_file, options, widths, total_statistics = nil, is_total: false)
  if is_total
    sum_totals = total_statistics.transpose.map(&:sum)
    format_statistics(*sum_totals, widths, options).join(' ')
  else
    lines = read_file.lines.count
    words = read_file.split.count
    characters = read_file.bytesize
    total_statistics << [lines, words, characters]
    format_statistics(lines, words, characters, widths, options).join(' ')
  end
end

def format_statistics(lines, words, characters, widths, options)
  values = [lines, words, characters]
  keys = %i[lines words characters]

  results = if options.empty?
              values
            else
              values.select.with_index { |_, i| options[keys[i]] }
            end
  results.map { |value| value.to_s.rjust(widths) }
end

def select_widths(max_width, options)
  if options.values.count(true) == 1
    keys = %i[lines words characters]
    active_key = keys.find { |key| options[key] }
    max_width[active_key]
  else
    ARGV.empty? ? 7 : 4
  end
end

def calc_max_widths(lists, options)
  all_statistics = []
  keys = %i[lines words characters]
  lists.each do |filename|
    file = File.open(filename)
    read_file = File.read(file)
    all_statistics << [read_file.lines.count, read_file.split.count, read_file.bytesize]
  end
  totals = all_statistics.transpose.map(&:sum)
  all_with_totals = all_statistics + [totals]
  max_width = keys.zip(all_with_totals.transpose.map { |column| column.max.to_s.length }).to_h

  return options.values.count(true) == 1 ? 0 : 7 if all_statistics.empty?

  select_widths(max_width, options)
end

max_widths = calc_max_widths(ARGV, options)

case ARGV.length
when 0
  read_file = $stdin.read
  puts file_statistics(read_file, options, max_widths, [])
when 1
  file = File.open(ARGV[0])
  read_file = File.read(file)
  puts "#{file_statistics(read_file, options, max_widths, [])} #{file.path}"
else
  statistics = []
  ARGV.each_with_index do |filename, index|
    file = File.open(filename)
    read_file = File.read(file)
    puts "#{file_statistics(read_file, options, max_widths, statistics)} #{file.path}"
    puts "#{file_statistics(nil, options, max_widths, statistics, is_total: true)} 合計" if index == ARGV.length - 1
  end
end
