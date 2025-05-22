# frozen_string_literal: true

class Frame
  def initialize(scores)
    @scores = scores
  end

  def frame_by_frame_score
    frames = @scores.each_slice(2).to_a
    frames
  end
end

