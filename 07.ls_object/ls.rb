#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'file_info'
require_relative 'width'

options = LsOption.new(ARGV)
flags = options.all? ? File::FNM_DOTMATCH : 0
filenames = Dir.glob('*', flags)
filenames.reverse! if options.reverse?
total_blocks = 0

file_infos = filenames.map do |filename|
  stats = FileInfo.new(filename)
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
