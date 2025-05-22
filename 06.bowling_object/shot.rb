#!/usr/bin/env ruby

class Shot
  attr_reader :scores, :score_per_throw

  def initialize(pin = ARGV[0])
    @scores = pin.split(',')
    @score_per_throw = score_per_throw
  end

  def score_per_throw
    @scores.flat_map do |x|
      x == 'X' ? [10,0] : [x.to_i]
    end
  end
end
