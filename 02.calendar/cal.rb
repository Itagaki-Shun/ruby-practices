#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new
option = {}
opt.on('-y [VAL]',Integer) {|v| option[:y] = v }
opt.on('-m [VAL]',Integer) {|v| option[:m] = v }
opt.parse!(ARGV)

argument_month = nil
argument_year = nil
# -mと-yに値があるかの確認、なければ今月を代入
if option[:y]
    argument_year = option[:y]
else
    argument_year = Date.today.year
end
if option[:m]
    argument_month = option[:m]
else
    argument_month = Date.today.month
end
date = Date.new(argument_year,argument_month)

first_day = Date.new(date.year, date.month, 1)
last_day = Date.new(date.year, date.month, -1)
puts "      #{date.year}年 #{date.month}月"

day_of_week = ['日 月 火 水 木 金 土']
puts day_of_week

if !(first_day.sunday?)
    print '  ' + '   ' * (first_day.wday - 1)
end

(first_day.day..last_day.day).each do |day|
    current_date = Date.new(date.year,date.month,day)
    # 10日以上で日曜日の日付はそのまま表示する
    if day >= 10 && current_date.sunday?
        print day
    # 10日以上（1桁）または、10日以内（1桁）で日曜日の場合は半角スペース1つ分あけて表示する
    elsif day >= 10 || day < 10 && current_date.sunday?
        print " #{day}"
    else
    # それ以外（1桁の日付）は半角スペース2つ分あけて表示する
        print "  #{day}"
    end

    if current_date.saturday?
        puts
    end
end
puts
