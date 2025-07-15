#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'perm'
require 'etc'

class FileInfo
  def initialize(filename)
    @stat = File.lstat(filename)
  end

  def file_mode
    perm = Perm.new
    perm.trans_type_and_permission(@stat)
  end

  def link
    @stat.nlink
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def bytesize
    @stat.size
  end

  def update_time
    @stat.mtime.strftime('%-m月 %e %H:%M')
  end

  def file_type(filename, options)
    if options.long_format?
      File.symlink?(filename) ? "#{filename} -> #{File.readlink(filename)}" : filename
    else
      filename
    end
  end
end
