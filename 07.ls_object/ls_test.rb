#!/usr/bin/env ruby

# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls_option'
require_relative 'permission'
require_relative 'file_info'
require_relative 'width'

class LsTest < Minitest::Test
  # 単数の場合
  def test_ls_option_singular
    # allオプションの場合
    option_a = LsOption.new(['-a'])
    assert option_a.all?
    refute option_a.reverse?
    refute option_a.long_format?

    # reverseオプションの場合
    option_r = LsOption.new(['-r'])
    refute option_r.all?
    assert option_r.reverse?
    refute option_r.long_format?

    # long_formatオプションの場合
    option_l = LsOption.new(['-l'])
    refute option_l.all?
    refute option_l.reverse?
    assert option_l.long_format?
  end

  # 複数オプションの場合
  def test_ls_option_multiple
    # allとreverse
    option_ar = LsOption.new(['-ar'])
    assert option_ar.all?
    assert option_ar.reverse?
    refute option_ar.long_format?

    # allとlong_format
    option_al = LsOption.new(['-al'])
    assert option_al.all?
    refute option_al.reverse?
    assert option_al.long_format?

    # 全部
    option_arl = LsOption.new(['-arl'])
    assert option_arl.all?
    assert option_arl.reverse?
    assert option_arl.long_format?
  end

  def test_perm
    perm = Perm.new
    file_stat = File.lstat('01.fizzbuzz')
    assert_equal 'drwxr-xr-x', perm.trans_type_and_permission(file_stat)

    file_stat = File.lstat('README.md')
    assert_equal '-rw-r--r--', perm.trans_type_and_permission(file_stat)
  end

  def test_file_info
    filename = '01.fizzbuzz'
    info = FileInfo.new(filename)
    assert_equal 4, info.blocks
    assert_equal 'drwxr-xr-x', info.file_mode
    assert_equal 3, info.link
    assert_equal 'itagaki_syun', info.owner
    assert_equal 'itagaki_syun', info.group
    assert_equal 4096, info.bytesize
    assert_equal '5月  8 14:56', info.update_time
    option_l = LsOption.new(['-l'])
    assert_equal '01.fizzbuzz', info.file_type(filename, option_l)
  end

  def test_width
    widths = Width.new
    stats1 = Struct.new(:link, :owner, :group, :bytesize)[5, 'alice', 'people', 1024]
    widths.update_max_widths(stats1)

    stats2 = Struct.new(:link, :owner, :group, :bytesize)[20, 'bob', 'dog', 512]
    widths.update_max_widths(stats2)

    assert_equal 2, widths.max_widths[:link]
    assert_equal 5, widths.max_widths[:owner]
    assert_equal 6, widths.max_widths[:group]
    assert_equal 4, widths.max_widths[:size]
  end
end
