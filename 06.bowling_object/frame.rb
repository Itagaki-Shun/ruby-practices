# frozen_string_literal: true

class Frame
  def initialize(scores)
    @scores = scores
  end

  def frame_by_frame_score
    @scores.each_slice(2).to_a
  end
end
