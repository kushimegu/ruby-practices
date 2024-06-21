#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  if ARGV.empty?
    input_lines, input_words, input_bytes = calculate_stats($stdin.read)
    output_with_options(input_lines, input_words, input_bytes, options)
  else
    files = ARGV
    total_stats = { lines: 0, words: 0, bytes: 0 }
    files.each_with_object(total_stats) do |file, totals|
      file_lines, file_words, file_bytes = calculate_stats(File.read(file))
      output_with_options(file_lines, file_words, file_bytes, options)
      puts file
      totals[:lines] += file_lines
      totals[:words] += file_words
      totals[:bytes] += file_bytes
    end
    if files.size > 1
      output_with_options(total_stats[:lines], total_stats[:words], total_stats[:bytes], options)
      print 'total'
    end
  end
end

def calculate_stats(data)
  lines = data.count("\n")
  words = data.split.size
  bytes = data.size
  [lines, words, bytes]
end

def output_with_options(lines, words, bytes, options)
  formatted_lines = four_digit_format(lines)
  formatted_words = four_digit_format(words)
  formatted_bytes = four_digit_format(bytes)
  print "#{formatted_lines} " if options['l']
  print "#{formatted_words} " if options['w']
  print "#{formatted_bytes} " if options['c']
  print "#{formatted_lines} #{formatted_words} #{formatted_bytes} " if options.values.none?
end

def four_digit_format(number)
  format('%4d', number)
end

main
