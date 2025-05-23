# frozen_string_literal: true

class Shot
  attr_reader :scores # テスト用のattr_reader

  def initialize(pin = ARGV[0])
    @scores = pin.split(',')
  end

  def score_per_throw
    @scores.flat_map do |x|
      x == 'X' ? [10, 0] : [x.to_i]
    end
  end
end
