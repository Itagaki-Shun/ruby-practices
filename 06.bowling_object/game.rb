# frozen_string_literal: true

class Game
  def initialize(frames)
    @frames = frames
  end

  def scoring
    @frames.each_with_index.sum do |shot, frame|
      point = shot.sum

      if frame < 9 # 9フレームまでの計算
        if shot[0] == 10 # ストライク
          point += if @frames[frame + 1][0] == 10 # 次のフレームもストライクか判定
                     @frames[frame + 1][0] + @frames[frame + 2][0]
                   else
                     @frames[frame + 1].sum
                   end
        elsif shot.sum == 10 # スペア
          point += @frames[frame + 1][0]
        end
      end

      point
    end
  end
end
