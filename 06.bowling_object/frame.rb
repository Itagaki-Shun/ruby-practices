# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def self.build_frames(rolls)
    frames = []
    i = 0

    9.times do
      if rolls[i].pins == 10
        frames << new([rolls[i]])
        i += 1
      else
        frames << new(rolls[i], rolls[i + 1])
        i += 2
      end
    end

    last_frame = rolls[i..] || []
    frames << new(*last_frame)
    frames
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

  def total_score(next_frames)
    return score if next_frames.empty?

    point = score

    if strike?
      bonus = next_frames.flat_map(&:shots)
      point + bonus[0].pins + bonus[1].pins
    elsif spare?
      bonus = next_frames.flat_map(&:shots)
      point + bonus[0].pins
    else
      point
    end
  end
end
