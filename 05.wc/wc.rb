#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('lwc')
  if ARGV.empty?
    stats = calculate_stats($stdin.read)
    output_with_options(stats, options)
  else
    files = ARGV
    total_stats = { lines: 0, words: 0, bytes: 0 }
    files.each do |file|
      stats = calculate_stats(File.read(file))
      output_with_options(stats, options, file)
      total_stats[:lines] += stats[:lines]
      total_stats[:words] += stats[:words]
      total_stats[:bytes] += stats[:bytes]
    end
    output_with_options(total_stats, options, 'total') if files.size > 1
  end
end

def calculate_stats(text)
  count_lines = text.count("\n")
  count_words = text.split.size
  calculate_bytes = text.size
  { lines: count_lines, words: count_words, bytes: calculate_bytes }
end

def output_with_options(stats, options, file_or_total = nil)
  no_option = options.values.none?
  formatted_lines = format_digits(stats[:lines])
  print "#{formatted_lines} " if options['l'] || no_option
  formatted_words = format_digits(stats[:words])
  print "#{formatted_words} " if options['w'] || no_option
  formatted_bytes = format_digits(stats[:bytes])
  print "#{formatted_bytes} " if options['c'] || no_option
  puts file_or_total if file_or_total
end

def format_digits(number)
  format('%4d', number)
end

main
