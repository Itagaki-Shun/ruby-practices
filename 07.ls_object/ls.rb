#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'file_info'
require_relative 'width'

options = LsOption.new(ARGV)
flags = options.all? ? File::FNM_DOTMATCH : 0
filenames = Dir.glob('*', flags)
filenames.reverse! if options.reverse?
