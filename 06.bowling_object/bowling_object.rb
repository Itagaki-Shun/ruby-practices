#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'game'

if ARGV.length.positive?
  rolls = ARGV[0].split(',')
  game = Game.new(rolls)
  puts game.score
else
  puts 'スコアを入力してください'
end
