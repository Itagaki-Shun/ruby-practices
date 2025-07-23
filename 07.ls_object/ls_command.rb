#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'file_info'
require_relative 'width'

class LsCommand
  def initialize(args)
    @options = LsOption.new(args)
    @flags = @options.all? ? File::FNM_DOTMATCH : 0
  end

  def output
    load_filenames
    if @options.long_format?
      puts "合計 #{@total_blocks}"
      puts long_format_lines(@file_infos)
    else
      column = 3
      max_widths = @filenames.map(&:length).max
      filename_lines = format_filenames_table(@filenames, max_widths, column)
      filename_lines.each { |row| puts row.compact.join }
    end
  end

  private

  def load_filenames
    @filenames = Dir.glob('*', @flags)
    @filenames.reverse! if @options.reverse?
    @file_infos = @filenames.map { |filename| FileInfo.new(filename) }
    @max_widths = Width.new(@file_infos).max_widths
    @total_blocks = @file_infos.sum(&:blocks)
  end

  def format_filenames_table(filenames, max_widths, columns)
    rows = (filenames.size.to_f / columns).ceil
    filename_table = Array.new(rows) { Array.new(columns) }

    filenames.each_with_index do |name, index|
      col, row = index.divmod(rows)
      filename_table[row][col] = name.ljust(max_widths + 1)
    end

    filename_table
  end

  def long_format_lines(file_infos)
    file_infos.map do |info|
      [
        info.file_mode,
        info.link.to_s.rjust(@max_widths[:link]),
        info.owner.to_s.ljust(@max_widths[:owner]),
        info.group.to_s.ljust(@max_widths[:group]),
        "#{info.bytesize.to_s.rjust(@max_widths[:size])} ",
        info.update_time,
        info.file_type
      ].join(' ')
    end
  end
end
