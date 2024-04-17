#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts('m:', 'y:')
today = Date.today
month = params["m"] ||= today.month
year = params["y"] ||= today.year
puts "#{month}月 #{year}".center(20)

puts "日 月 火 水 木 金 土"

first_date = Date.new(year.to_i, month.to_i, 1)
last_date = Date.new(year.to_i, month.to_i, -1)

print "   " * first_date.wday

(first_date..last_date).each do |date|
  if date == today
    print "\e[37m\e[40m"
    print sprintf("%2d", date.day)
    print "\e[0m"
  else
    print sprintf("%2d", date.day)
  end
  
  if date.saturday?
    print "\n"
  else
    print " "
  end
end
