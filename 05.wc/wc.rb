#! /usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:characters] = true }
end.parse!

KEYS = %i[lines words characters].freeze

def file_statistics(content)
  [
    content.lines.count,
    content.split.count,
    content.bytesize
  ]
end

def format_statistics(statistics, widths, options)
  results = if options.empty?
              statistics
            else
              statistics.select.with_index { |_, i| options[KEYS[i]] }
            end
  results.map { |value| value.to_s.rjust(widths) }
end

def calc_widths(lists, options)
  totals = lists.transpose.map(&:sum)
  all_with_totals = lists + [totals]
  max_width = KEYS.zip(all_with_totals.transpose.map { |column| column.max.to_s.length }).to_h

  if options.values.count(true) == 1 && lists.size == 1
    active_key = KEYS.find { |key| options[key] }
    max_width[active_key]
  else
    ARGV.empty? ? 7 : 4
  end
end

case ARGV.length
when 0
  read_file = $stdin.read
  statistics = file_statistics(read_file)
  max_widths = calc_widths([statistics], options)
  puts format_statistics(statistics, max_widths, options).join(' ')
when 1
  read_file = File.read(ARGV[0])
  statistics = file_statistics(read_file)
  max_widths = calc_widths([statistics], options)
  puts "#{format_statistics(statistics, max_widths, options).join(' ')} #{ARGV[0]}"
else
  all_statistics = ARGV.map do |filename|
    read_file = File.read(filename)
    file_statistics(read_file)
  end

  max_widths = calc_widths(all_statistics, options)

  ARGV.each_with_index do |filename, index|
    statistics = all_statistics[index]
    puts "#{format_statistics(statistics, max_widths, options).join(' ')} #{filename}"
  end

  total_statistics = all_statistics.transpose.map(&:sum)
  puts "#{format_statistics(total_statistics, max_widths, options).join(' ')} 合計"
end
