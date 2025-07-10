#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

class LsOption
  attr_reader :options

  def initialize(args = ARGV)
    @options = {}
    parse(args)
  end

  def parse(args)
    OptionParser.new do |opts|
      opts.on('-a') { @options[:all] = true }
      opts.on('-r') { @options[:reverse] = true }
      opts.on('-l') { @options[:long_format] = true }
    end.parse!(args)
  end

  def all?
    @options[:all]
  end

  def reverse?
    @options[:reverse]
  end

  def long_format?
    @options[:long_format]
  end
end
