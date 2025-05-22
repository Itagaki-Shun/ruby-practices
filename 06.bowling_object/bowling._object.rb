#!/usr/bin/env ruby

require_relative 'shot'
require_relative 'frame'
require_relative 'game'

if ARGV.length.positive?
  shot = Shot.new(ARGV[0])
  frame = Frame.new(shot.score_per_throw)
  game = Game.new(frame.frame_by_frame_score)
  p game.scoring
else
  puts 'スコアを入力してください'
end
