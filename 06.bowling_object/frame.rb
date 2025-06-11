# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(*shots)
    @shots = shots.flatten
  end

  def self.build_frames(rolls)
    i = 0

    frames = Array.new(10) do |frame_idx|
      if frame_idx < 9 # 9フレームまで
        if rolls[i].pins == 10
          frames = new([rolls[i]])
          i += 1
        else
          frames = new(rolls[i], rolls[i + 1])
          i += 2
        end
        frames
      else # 最終フレーム
        last_frame = rolls[i..] || []
        new(*last_frame)
      end
    end
  end

  def score
    shots.sum(&:pins)
  end

  def strike?
    shots.size == 1 && shots[0].pins == 10
  end

  def spare?
    shots.size >= 2 && shots[0..1].map(&:pins).sum == 10
  end

  def total_score(next_frames)
    return score if next_frames.empty?

    point = score

    if strike?
      bonus = next_frames.flat_map(&:shots)
      point + bonus[0..1].map(&:pins).sum
    elsif spare?
      bonus = next_frames.flat_map(&:shots)
      point + bonus[0].pins
    else
      point
    end
  end
end
