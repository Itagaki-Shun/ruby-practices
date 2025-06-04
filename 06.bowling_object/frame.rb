# frozen_string_literal: true

class Frame
  attr_reader :rolls

  def initialize(rolls)
    @rolls = rolls
  end

  def score
    @rolls.sum
  end

  def first_roll
    @rolls[0]
  end

  def second_roll
    @rolls[1]
  end

  def strike?
    first_roll == 10
  end

  def spare?
    !strike? && @rolls.sum == 10
  end
end
