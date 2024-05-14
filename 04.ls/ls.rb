#!/usr/bin/env ruby
# frozen_string_literal: true

def make_chart(files, row:)
  column = if (files.size % row).zero?
             files.size / row
           else
             files.size / row + 1
           end

  @chart = Array.new(column) { Array.new(row, nil) }
  files.each_with_index do |file, index|
    column_number = index % column
    row_number = index / column
    @chart[column_number][row_number] = file
  end
end

def output_chart(files, chart)
  max_length = files.map(&:length).max

  chart.each do |row|
    row.each do |file|
      print file.ljust(max_length + 1) unless file.nil?
    end
    print "\n"
  end
end

files = Dir.glob('*')
make_chart(files, row: 3)
output_chart(files, @chart)
