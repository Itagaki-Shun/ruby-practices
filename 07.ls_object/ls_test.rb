#!/usr/bin/env ruby

# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls_option'
require_relative 'perm'

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
end
