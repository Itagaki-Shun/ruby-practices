# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def score
    shots.sum(&:pins)
  end

  def strike?
    shots.size == 1 && shots[0].pins == 10
  end

  def spare?
    shots.size >= 2 && shots[0].pins + shots[1].pins == 10
  end
end
