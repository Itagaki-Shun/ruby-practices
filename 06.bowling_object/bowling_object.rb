#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'game'

if ARGV.length.positive?
  shot = Shot.new(ARGV[0])
  frame = Frame.new(shot.score_per_throw)
  game = Game.new(frame.frame_by_frame_score)
  puts game.scoring
else
  puts 'スコアを入力してください'
end
