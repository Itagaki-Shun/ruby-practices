# frozen_string_literal: true

class Game
  def initialize(frames)
    @frames = frames
  end

  def scoring
    point = @frames.each_with_index.sum do |frame, index|
      point = frame.sum

      if index < 9 # 9フレームまでの計算
        if frame[0] == 10 # ストライク
          point += if @frames[index + 1][0] == 10 # 次のフレームもストライクか判定
                    @frames[index + 1][0] + @frames[index + 2][0]
                  else
                    @frames[index + 1].sum
                  end
        elsif frame.sum == 10 # スペア
          point += @frames[index + 1][0]
        end
      end

      point
    end
  end
end
