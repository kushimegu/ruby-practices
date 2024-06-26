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
    total_stats = { lines: 0, words: 0, bytes: 0, name: 'total' }
    files.each do |file|
      stats = calculate_stats(File.read(file), file)
      output_with_options(stats, options)
      total_stats[:lines] += stats[:lines]
      total_stats[:words] += stats[:words]
      total_stats[:bytes] += stats[:bytes]
    end
    output_with_options(total_stats, options) if files.size > 1
  end
end

def calculate_stats(text, file = nil)
  {
    lines: text.count("\n"),
    words: text.split.size,
    bytes: text.size,
    name: file
  }
end

def output_with_options(stats, options)
  no_option = options.values.none?
  formatted_lines = format_digits(stats[:lines])
  print "#{formatted_lines} " if options['l'] || no_option
  formatted_words = format_digits(stats[:words])
  print "#{formatted_words} " if options['w'] || no_option
  formatted_bytes = format_digits(stats[:bytes])
  print "#{formatted_bytes} " if options['c'] || no_option
  puts stats[:name]
end

def format_digits(number)
  format('%4d', number)
end

main
