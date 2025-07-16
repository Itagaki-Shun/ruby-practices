#!/usr/bin/env ruby

# frozen_string_literal: true

class Width
  attr_reader :max_widths

  def initialize
    @max_widths = {
      link: 0,
      owner: 0,
      group: 0,
      size: 0
    }
  end

  def update_max_widths(stats)
    @max_widths[:link] = [@max_widths[:link], stats.link.to_s.length].max
    @max_widths[:owner] = [@max_widths[:owner], stats.owner.to_s.length].max
    @max_widths[:group] = [@max_widths[:group], stats.group.to_s.length].max
    @max_widths[:size] = [@max_widths[:size], stats.bytesize.to_s.length].max
  end
end
