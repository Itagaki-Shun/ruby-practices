#!/usr/bin/env ruby

# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'shot'
require_relative 'frame'
require_relative 'game'

class BowlingTest < Minitest::Test
  def test_shot
    first_shot = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X 6 4 5], first_shot.scores
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 0, 9, 1, 8, 0, 10, 0, 6, 4, 5], first_shot.score_per_throw

    second_shot = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X X X], second_shot.scores
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 0, 9, 1, 8, 0, 10, 0, 10, 0, 10, 0, 10, 0], second_shot.score_per_throw

    third_shot = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal %w[X X X X X X X X X X X X], third_shot.scores
    assert_equal [10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0], third_shot.score_per_throw
  end

  def test_frame
    frame = Frame.new([6, 3])
    assert_equal 9, frame.score
    assert_equal 6, frame.first_roll
    assert_equal 3, frame.second_roll

    strike_frame = Frame.new([10, 0])
    assert strike_frame.strike?
    refute strike_frame.spare?

    spare_frame = Frame.new([6, 4])
    assert spare_frame.spare?
    refute spare_frame.strike?

    spare_or_strike_frame = Frame.new([0, 10])
    refute spare_or_strike_frame.strike?
    assert spare_or_strike_frame.spare?
  end

  def test_game
    first_shot = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    first_frame = Frame.new(first_shot.score_per_throw)
    first_game = Game.new(first_frame.frame_by_frame_score)
    assert_equal 139, first_game.scoring

    second_shot = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    second_frame = Frame.new(second_shot.score_per_throw)
    second_game = Game.new(second_frame.frame_by_frame_score)
    assert_equal 164, second_game.scoring

    third_shot = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    third_frame = Frame.new(third_shot.score_per_throw)
    third_game = Game.new(third_frame.frame_by_frame_score)
    assert_equal 300, third_game.scoring
  end
end
