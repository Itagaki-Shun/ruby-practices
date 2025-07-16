#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'file_info'
require_relative 'width'

def format_filenames_table(filenames, max_widths, columns)
  rows = (filenames.size.to_f / columns).ceil
  filename_table = Array.new(rows) { Array.new(columns) }

  filenames.each_with_index do |name, index|
    col, row = index.divmod(rows)
    filename_table[row][col] = name.ljust(max_widths + 1)
  end

  filename_table
end

def long_format_lines(file_infos, max_widths)
  file_infos.map do |info|
    [
      info[:mode],
      info[:link].to_s.rjust(max_widths[:link]),
      info[:owner].to_s.ljust(max_widths[:owner]),
      info[:group].to_s.ljust(max_widths[:group]),
      "#{info[:size].to_s.rjust(max_widths[:size])} ",
      info[:time],
      info[:type]
    ].join(' ')
  end
end

options = LsOption.new(ARGV)
flags = options.all? ? File::FNM_DOTMATCH : 0
filenames = Dir.glob('*', flags)
filenames.reverse! if options.reverse?
total_blocks = 0

widths = Width.new

file_infos = filenames.map do |filename|
  stats = FileInfo.new(filename)
  widths.update_max_widths(stats)
  if options.long_format?
    total_blocks += stats.blocks
    {
      mode: stats.file_mode,
      link: stats.link,
      owner: stats.owner,
      group: stats.group,
      size: stats.bytesize,
      time: stats.update_time,
      type: stats.file_type(filename, options)
    }
  else
    stats.file_type(filename, options)
  end
end

max_widths = widths.max_widths

if options.long_format?
  puts "合計 #{total_blocks}"
  puts long_format_lines(file_infos, max_widths)
else
  column = 3
  max_widths = filenames.map(&:length).max
  filename_lines = format_filenames_table(file_infos, max_widths, column)
  filename_lines.each { |row| puts row.compact.join }
end
