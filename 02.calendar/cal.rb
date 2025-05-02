#!/usr/bin/env ruby
day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week
require 'date'
date = Date.new(2025,5)
first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)

(1..last_day.day).each do |day|
    print day
    if (day + first_day.wday) % 7 === 0
        puts ''
    end
end
