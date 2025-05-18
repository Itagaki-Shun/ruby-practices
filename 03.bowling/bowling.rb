#!/usr/bin/env ruby

# frozen_string_literal: true

scores = []

ARGV.each do |arg|
  scores = arg.split(',')
end

scores = scores.flat_map do |x|
  x == 'X' ? [10, 0] : [x.to_i]
end

frames = scores.each_slice(2).to_a

point = 0
frames.each_with_index do |frame, index|
  if index < 9 # 9フレームまでの計算
    if frame[0] == 10 # ストライク
      point = if frames[index + 1].include?(10) # 次のフレームもストライクか判定
                point + 10 + frames[index + 1][0] + frames[index + 2][0]
              else
                point + 10 + frames[index + 1][0] + frames[index + 1][1]
              end
    elsif frame.sum == 10 # スペア
      point += 10 + frames[index + 1][0]
    else
      point += frame.sum
    end
  else # 最終フレームの計算
    point += frame.sum
  end
end
puts point
