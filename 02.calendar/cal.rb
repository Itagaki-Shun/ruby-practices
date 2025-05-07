#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new
option = {}
opt.on('-y [VAL]',Integer) {|v| option[:y] = v }
opt.on('-m [VAL]',Integer) {|v| option[:m] = v }
opt.parse!(ARGV)

if option[:y] == nil
    option[:y] = Date.today.year
elsif option[:m] == nil
    option[:m] = Date.today.month
end
if option[:y] != nil && option[:m] != nil
    date = Date.new(option[:y],option[:m])
else
    date = Date.today
end
first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)
puts "      #{date.year}年 #{date.month}月"

day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week

if first_day.wday > 0
    print '  ' + '   ' * (first_day.wday - 1)
end
(1..last_day.day).each do |day|
    if day >= 10 && (day + first_day.wday) % 7 === 1
        print day
        
    elsif day >= 10 || (day < 10 && (day + first_day.wday) % 7 === 1)
        print " #{day}"
    else
        print "  #{day}"
    end
    if (day + first_day.wday) % 7 === 0
        puts ''
    end
end
puts ''
