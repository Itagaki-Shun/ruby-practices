#!/usr/bin/env ruby

class Shot
  attr_reader :scores

  def initialize(pin = ARGV[0])
    @scores = pin.split(',')
  end
end
