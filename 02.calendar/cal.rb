#!/usr/bin/env ruby
day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week

require 'date'
date = Date.new(2025,5)
first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)
puts first_day
puts first_day.wday
puts last_day
puts last_day.wday