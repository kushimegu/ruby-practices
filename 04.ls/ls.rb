#!/usr/bin/env ruby
# frozen_string_literal: true

def make_chart(files, column:)
  row = if (files.size % column).zero?
          files.size / column
        else
          files.size / column + 1
        end

  @chart = Array.new(row) { Array.new(column, nil) }
  files.each_with_index do |file, i|
    row_number = i % row
    column_number = i / row
    @chart[row_number][column_number] = file
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
make_chart(files, column: 3)
output_chart(files, @chart)
