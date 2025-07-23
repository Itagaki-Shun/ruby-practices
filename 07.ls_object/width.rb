#!/usr/bin/env ruby

# frozen_string_literal: true

class Width
  attr_reader :max_widths

  def initialize(stats)
    @max_widths = {
      link: stats.map { |s| s.link.to_s.length }.max,
      owner: stats.map { |s| s.owner.to_s.length }.max,
      group: stats.map { |s| s.group.to_s.length }.max,
      size: stats.map { |s| s.bytesize.to_s.length }.max
    }
  end
end
