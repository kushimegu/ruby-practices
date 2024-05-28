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

def output_matrix(files, matrix)
  max_length = files.map(&:length).max

  matrix.each do |row|
    row.each do |file|
      print file.ljust(max_length + 1) unless file.nil?
    end
    puts
  end
end

options = ARGV.getopts('a')
files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
matrix = make_matrix(files, 3)
output_matrix(files, matrix)
