#!/usr/bin/env ruby

# frozen_string_literal: true

if ARGV.length > 0
  scores = ARGV[0].split(',')
end

scores = scores.flat_map do |x|
  x == 'X' ? [10, 0] : [x.to_i]
end

frames = scores.each_slice(2).to_a

point = frames.each_with_index.sum do |frame, index|
  if index < 9 # 9フレームまでの計算
    if frame[0] == 10 # ストライク
      if frames[index + 1][0] == 10 # 次のフレームもストライクか判定
        10 + frames[index + 1][0] + frames[index + 2][0]
      else
        10 + frames[index + 1][0] + frames[index + 1][1]
      end
    elsif frame.sum == 10 # スペア
      10 + frames[index + 1][0]
    else
      frame.sum
    end
  else # 最終フレームの計算
    frame.sum
  end
end
puts point
