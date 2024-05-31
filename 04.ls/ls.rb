#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def make_matrix(files, column)
  row = files.size.ceildiv(column)

  matrix = Array.new(row) { Array.new(column, nil) }
  files.each_with_index do |file, i|
    row_number = i % row
    column_number = i / row
    matrix[row_number][column_number] = file
  end
  matrix
end

def calculate_width(name)
  return 0 if name.nil?

  name.each_char.map { |char| char.bytesize == 1 ? 1 : 2 }.sum
end

def output_matrix(files, matrix)
  max_width = files.map { |file| calculate_width(file) }.max + 1

  matrix.each do |row|
    row.each do |file|
      next if file.nil?

      width = max_width - calculate_width(file) + file.length
      print file.ljust(width)
    end
    puts
  end
end

options = ARGV.getopts('r')
files = options['r'] ? Dir.glob('*').reverse : Dir.glob('*')
matrix = make_matrix(files, 3)
output_matrix(files, matrix)
