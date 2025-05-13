#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new
option = {}
opt.on('-y [VAL]',Integer) {|v| option[:y] = v }
opt.on('-m [VAL]',Integer) {|v| option[:m] = v }
opt.parse!(ARGV)

month = nil
year = nil
year = option[:y] || Date.today.year
month = option[:m] || Date.today.month

date = Date.new(year,month)

first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)
puts "      #{date.year}年 #{date.month}月"

day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week

# 初日の位置を決める処理（日曜日であればスペースは空けない）
print '   ' *first_day.wday
(first_day.day..last_day.day).each do |day|
    current_date = Date.new(date.year,date.month,day)
    print format('%2d ',day)
    puts if current_date.saturday?
end
puts
