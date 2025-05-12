#!/usr/bin/env ruby
scores = []
frames = []
ARGV.each do |arg|
    scores = arg.split(',')
end

scores = scores.flat_map.with_index do |x,i|
    if i < 16
        x == 'X' ? [10,0] : [x.to_i] if i < 16
    # 10フレーム目にストライクやスペアがあったときは10のみ入れる
    else
        x == 'X' ? [10] :[x.to_i]
    end
end

scores.each_slice(2) do |score|
    frames.push(score)
end
p frames
point = 0

frames.each_with_index do |frame,index|
    if index < 9
        if frame[0] == 10 #ストライク
            point += 10 + frames[index + 1][0] + frames[index + 1][1]
        elsif frame.sum == 10
            point += 10 + frames[index + 1][0]
        else
            point += frame.sum
        end
    else
        point += frame.sum
    end
end
puts point


