#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def main
  options = ARGV.getopts('l')
  files = Dir.glob('*')
  if options['l']
    total_blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"
    files.each do |file|
      stats = list_stats(file)
      output_stats(stats)
      puts
    end
  else
    matrix = make_matrix(files, 3)
    output_matrix(files, matrix)
  end
end

def file_type(number)
  type = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => '|',
    '14' => 's'
  }
  type[number]
end

def file_mode(number)
  mode = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  mode[number]
end

def format_time_or_year(mtime)
  now = Time.now
  today = now.to_date
  if mtime.to_date >= today.prev_month(6) && mtime < now
    mtime.strftime('%H:%M')
  else
    format('%5d', mtime.strftime('%Y'))
  end
end

def list_stats(file)
  stats = File.stat(file)
  mode = format('%06o', stats.mode)
  type = file_type(mode[0, 2])
  mode_owner = file_mode(mode[3])
  mode_group = file_mode(mode[4])
  mode_other = file_mode(mode[5])
  link = stats.nlink
  user_name = Etc.getpwuid(stats.uid).name
  group_name = Etc.getgrgid(stats.gid).name
  size = format('%4d', stats.size)
  mtime = stats.mtime
  month = format('%2d', mtime.month)
  day = format('%2d', mtime.day)
  time_or_year = format_time_or_year(mtime)
  [type + mode_owner + mode_group + mode_other, link, user_name, group_name, size, month, day, time_or_year, file]
end

def output_stats(stats)
  stats.each do |stat|
    print "#{stat} "
  end
end

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

main
