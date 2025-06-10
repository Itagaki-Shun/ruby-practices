# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(scores)
    rolls = scores.map { |m| Shot.new(m) }
    @frames = Frame.build_frames(rolls)
  end

  def score
    @frames.each_with_index.sum do |frame, idx|
      next_frames = @frames[(idx + 1)..] || []
      frame.total_score(next_frames)
    end
  end
end
