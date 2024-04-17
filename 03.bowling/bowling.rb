#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

frames = []
frame = []
scores.each do |roll|
  frame << (roll == 'X' ? 10 : roll.to_i)

  next if frames.length < 9 && frame.length == 1 && frame != [10]
  next if frames.length == 9 && (frame.length == 1 || (frame.length == 2 && frame.sum >= 10))

  frames << frame
  frame = []
end

point = 0
frames.each_with_index do |frame_rolls, i|
  point += frame_rolls.sum
  break if i == 9

  point += if frame_rolls == [10]
             if frames[i + 1] == [10]
               10 + frames[i + 2][0]
             else
               frames[i + 1][0] + frames[i + 1][1]
             end

           elsif frame_rolls != [10] && frame_rolls.sum == 10
             frames[i + 1][0]
           else
             0
           end
end
puts point
