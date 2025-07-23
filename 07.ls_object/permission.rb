#!/usr/bin/env ruby

# frozen_string_literal: true

class Permission
  FILE_TYPE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  FILE_PERMISSION = {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }.freeze

  private_constant :FILE_TYPE, :FILE_PERMISSION

  def trans_type_and_permission(file_info)
    octal = file_info.mode.to_s(8)[-3..].chars.map(&:to_i)
    permission = octal.map { |val| FILE_PERMISSION[val] }.join

    FILE_TYPE[file_info.ftype] + permission
  end
end
