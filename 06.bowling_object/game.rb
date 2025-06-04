# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames.map { |rolls| Frame.new(rolls) }
  end

  def scoring
    @frames.each_with_index.sum do |shot, frame|
      point = shot.score

      if frame < 9 # 9フレームまでの計算
        if shot.strike? # ストライク
          point += if @frames[frame + 1].strike? # 次のフレームもストライクか判定
                     @frames[frame + 1].first_roll + @frames[frame + 2].first_roll
                   else
                     @frames[frame + 1].score
                   end
        elsif shot.spare? # スペア
          point += @frames[frame + 1].first_roll
        end
      end

      point
    end
  end
end
