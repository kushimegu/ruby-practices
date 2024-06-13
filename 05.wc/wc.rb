#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def count_lines(data)
  format('%4d', data.count("\n"))
end

def count_words(data)
  format('%4d', data.split.size)
end

def calculate_bytes(data)
  format('%4d', data.size)
end

def list_options(options)
  { l: options['l'], w: options['w'], c: options['c'] }
end

def sort_output(lines, words, bytes)
  { l: lines, w: words, c: bytes }
end

def output_with_options(lines, words, bytes, options)
  list_options(options).each do |option, is_true|
    print "#{sort_output(lines, words, bytes)[option]} " if is_true
  end
end

options = ARGV.getopts('lwc')
if ARGV == []
  input_data = $stdin.read
  input_lines = count_lines(input_data)
  input_words = count_words(input_data)
  input_bytes = calculate_bytes(input_data)
  if list_options(options).values.uniq.length == 1
    print "#{input_lines} #{input_words} #{input_bytes}"
  else
    output_with_options(input_lines, input_words, input_bytes, options)
  end
else
  files = ARGV
  files.each do |file|
    file_data = File.read(file)
    file_lines = count_lines(file_data)
    file_words = count_words(file_data)
    file_bytes = calculate_bytes(file_data)
    if list_options(options).values.uniq.length == 1
      print "#{file_lines} #{file_words} #{file_bytes} #{file}"
    else
      output_with_options(file_lines, file_words, file_bytes, options)
      print file
    end
    puts
  end
  if files.size > 1
    total_lines = format('%4d', files.sum { |file| count_lines(File.read(file)).to_i })
    total_words = format('%4d', files.sum { |file| count_words(File.read(file)).to_i })
    total_bytes = format('%4d', files.sum { |file| calculate_bytes(File.read(file)).to_i })
    if list_options(options).values.uniq.length == 1
      print "#{total_lines} #{total_words} #{total_bytes} total"
    else
      output_with_options(total_lines, total_words, total_bytes, options)
      print 'total'
    end
  end
end
