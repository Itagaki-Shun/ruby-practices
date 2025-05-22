#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'shot'

class BowlingTest < Minitest::Test
  def test_shot
    shot_1 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal ["6", "3", "9", "0", "0", "3", "8", "2", "7", "3", "X", "9", "1", "8", "0", "X", "6", "4", "5"], shot_1.scores
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 0, 9, 1, 8, 0, 10, 0, 6, 4, 5], shot_1.score_per_throw

    shot_2 = Shot.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal ["6", "3", "9", "0", "0", "3", "8", "2", "7", "3", "X", "9", "1", "8", "0", "X", "X", "X", "X"], shot_2.scores
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 0, 9, 1, 8, 0, 10, 0, 10, 0, 10, 0, 10, 0], shot_2.score_per_throw

    shot_3 = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X"], shot_3.scores
    assert_equal [10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0], shot_3.score_per_throw
  end
end
