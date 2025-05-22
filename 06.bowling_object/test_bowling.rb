#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'shot'
require_relative 'frame'
require_relative 'game'

class BowlingTest < Minitest::Test
  def test_shot
    shot_1 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X 6 4 5], shot_1.scores
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 0, 9, 1, 8, 0, 10, 0, 6, 4, 5], shot_1.score_per_throw

    shot_2 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X X X], shot_2.scores
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 0, 9, 1, 8, 0, 10, 0, 10, 0, 10, 0, 10, 0], shot_2.score_per_throw

    shot_3 = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal %w[X X X X X X X X X X X X], shot_3.scores
    assert_equal [10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0], shot_3.score_per_throw
  end

  def test_frame
    shot_1 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    frame_1 = Frame.new(shot_1.score_per_throw)
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [6, 4], [5]], frame_1.frame_by_frame_score

    shot_2 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    frame_2 = Frame.new(shot_2.score_per_throw)
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [10, 0], [10, 0], [10, 0]], frame_2.frame_by_frame_score

    shot_3 = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    frame_3 = Frame.new(shot_3.score_per_throw)
    assert_equal [[10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0], [10, 0]], frame_3.frame_by_frame_score
  end

  def test_game
    shot_1 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    frame_1 = Frame.new(shot_1.score_per_throw)
    game_1 = Game.new(frame_1.frame_by_frame_score)
    assert_equal 139, game_1.scoring

    shot_2 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    frame_2 = Frame.new(shot_2.score_per_throw)
    game_2 = Game.new(frame_2.frame_by_frame_score)
    assert_equal 164, game_2.scoring

    shot_3 = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    frame_3 = Frame.new(shot_3.score_per_throw)
    game_3 = Game.new(frame_3.frame_by_frame_score)
    assert_equal 300, game_3.scoring
  end
end
