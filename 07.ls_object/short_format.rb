# frozen_string_literal: true

require_relative 'base_format'

class ShortFormat < BaseFormat
  def output
    matrix = make_matrix
    max_width = @files.map { |file| calculate_width(file) }.max + 1

    matrix.each do |row|
      row.each do |file|
        next if file.nil?

        width = max_width - calculate_width(file) + file.length
        print file.ljust(width)
      end
      puts
    end
  end

  private

  COLUMN_COUNT = 3

  def make_matrix
    row = @files.size.ceildiv(COLUMN_COUNT)

    matrix = Array.new(row) { Array.new(COLUMN_COUNT, nil) }
    @files.each_with_index do |file, i|
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
end
