#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  if ARGV.empty?
    input_stats = calculate_stats($stdin.read)
    output_with_options(input_stats, options)
  else
    files = ARGV
    total_stats = { lines: 0, words: 0, bytes: 0 }
    files.each_with_object(total_stats) do |file, totals|
      file_stats = calculate_stats(File.read(file))
      output_with_options(file_stats, options)
      puts file
      totals[:lines] += file_stats[:lines]
      totals[:words] += file_stats[:words]
      totals[:bytes] += file_stats[:bytes]
    end
    if files.size > 1
      output_with_options(total_stats, options)
      puts 'total'
    end
  end
end

def calculate_stats(input_data)
  count_lines = input_data.count("\n")
  count_words = input_data.split.size
  calculate_bytes = input_data.size
  { lines: count_lines, words: count_words, bytes: calculate_bytes }
end

def output_with_options(stats, options)
  formatted_lines = digit_format(stats[:lines])
  formatted_words = digit_format(stats[:words])
  formatted_bytes = digit_format(stats[:bytes])
  print "#{formatted_lines} " if options['l'] || options.values.none?
  print "#{formatted_words} " if options['w'] || options.values.none?
  print "#{formatted_bytes} " if options['c'] || options.values.none?
end

def digit_format(number)
  format('%4d', number)
end

main
