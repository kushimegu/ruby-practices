#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts('m:', 'y:')
month = params["m"]||=Date.today.month
year = params["y"]||=Date.today.year
puts "#{month}月 #{year}".center(20)

puts "日 月 火 水 木 金 土"

date_first = Date.new(year.to_i, month.to_i, 1)
date_last = Date.new(year.to_i, month.to_i, -1)

print "   " * date_first.wday

(date_first..date_last).each do |date|
  if date == Date.today
    print "\e[37m\e[40m"
    print sprintf("%2d", date.day.to_s)
    print "\e[0m"
  else
    print sprintf("%2d", date.day.to_s)
  end
  
  if date.saturday?
    print "\n"
  else
    print " "
  end
end
