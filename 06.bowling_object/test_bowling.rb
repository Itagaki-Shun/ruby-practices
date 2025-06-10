#!/usr/bin/env ruby

# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'shot'
require_relative 'frame'
require_relative 'game'

class BowlingTest < Minitest::Test
  def test_shot
    first_shot = Shot.new('6')
    assert_equal 6, first_shot.pins

    second_shot = Shot.new('3')
    assert_equal 3, second_shot.pins

    third_shot = Shot.new('X')
    assert_equal 10, third_shot.pins
  end

  def test_frame
    frame = Frame.new([Shot.new('6'), Shot.new('3')])
    assert_equal 9, frame.score

    strike_frame = Frame.new([Shot.new('X')])
    assert strike_frame.strike?
    refute strike_frame.spare?

    spare_frame = Frame.new([Shot.new('6'), Shot.new('4')])
    assert spare_frame.spare?
    refute spare_frame.strike?

    spare_or_strike_frame = Frame.new([Shot.new('0'), Shot.new('10')])
    refute spare_or_strike_frame.strike?
    assert spare_or_strike_frame.spare?
  end

  def test_game
    first_shot = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    frames = first_shot.score_per_throw
    first_game = Game.new(frames)
    assert_equal 139, first_game.scoring

    second_shot = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    frames = second_shot.score_per_throw
    second_game = Game.new(frames)
    assert_equal 164, second_game.scoring

    third_shot = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    frames = third_shot.score_per_throw
    third_game = Game.new(frames)
    assert_equal 300, third_game.scoring
  end
end
