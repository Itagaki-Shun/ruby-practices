#!/usr/bin/env ruby

array =[]

# ARGV.each_with_index do |argv, i|
#     case 
#     when ARGV[i] === '-y'
#         array.push(ARGV[i + 1])
#     when ARGV[i] === '-m'
#         array.push(ARGV[i + 1])
#     end
# end

require 'optparse'
opt = OptionParser.new
option = {}

opt.on('-y [VAL]') {|v| option[:y] = v }
opt.on('-m [VAL]') {|v| option[:m] = v }
opt.parse!(ARGV)

if option[:y]
    array.push(option[:y])
end
if option[:m]
    array.push(option[:m])
end
array.push('01')

require 'date'
# date = Date.today
date = Date.parse(array.join('-'))
first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)
puts "      #{date.year}年 #{date.month}月"

day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week
print '  ' + '   ' * (first_day.wday)
(1..last_day.day).each do |day|
    case
    when day >= 10 && (day + first_day.wday) % 7 === 1
        print day
        
    when day >= 10 || (day < 10 && (day + first_day.wday) % 7 === 1)
        print " #{day}"
    else
        print "  #{day}"
    end
    if (day + first_day.wday) % 7 === 0
        puts ''
    end
end
puts ''