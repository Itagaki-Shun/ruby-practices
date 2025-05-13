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
# -mと-yに値があるかの確認、なければ今月を代入
if option[:y]
    year = option[:y]
else
    year = Date.today.year
end
if option[:m]
    month = option[:m]
else
    month = Date.today.month
end
date = Date.new(year,month)

first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)
puts "      #{date.year}年 #{date.month}月"

day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week

# 初日の位置を決める処理（日曜日であればスペースは空けない）
print (first_day.wday == 0 ? '' : '  ' + '   ' * (first_day.wday - 1))
(first_day.day..last_day.day).each do |day|
    current_date = Date.new(date.year,date.month,day)
    if current_date.wday > 0
        print format('%3d',day)
        puts if current_date.saturday?
    else
        print format('%2d',day)
    end
end
puts
