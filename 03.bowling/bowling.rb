#!/usr/bin/env ruby
scores = []
frames = []
ARGV.each do |arg|
    scores = arg.split(',')
end

scores = scores.flat_map do |x|
    x == 'X' ? [10,0] : [x.to_i]
end

scores.each_slice(2) do |i|
    frames.push(i)
end


