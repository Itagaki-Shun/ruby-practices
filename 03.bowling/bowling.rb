#!/usr/bin/env ruby
score = []
frame = []
ARGV.each do |arg|
    score = arg.split(',')
end

score = score.flat_map do |x|
    x == 'X' ? [10,0] : [x.to_i]
end

p score
