#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'permission'
require 'etc'

class FileInfo
  def initialize(filename)
    @filename = filename
    @stat = File.lstat(filename)
  end

  def blocks
    @stat.blocks / 2
  end

  def file_mode
    permission = Permission.new
    permission.trans_type_and_permission(@stat)
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

  def file_type
    File.symlink?(@filename) ? "#{@filename} -> #{File.readlink(@filename)}" : @filename
  end
end
