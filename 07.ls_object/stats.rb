# frozen_string_literal: true

require 'etc'
require 'date'

class Stats
  def initialize(file)
    @file = file
  end

  FILE_TYPE_MAP = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => '|',
    '14' => 's'
  }.freeze

  FILE_MODE_MAP = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def list
    stats = File.stat(@file)
    mode = format('%06o', stats.mode)
    type = FILE_TYPE_MAP[mode[0, 2]]
    mode_owner = FILE_MODE_MAP[mode[3]]
    mode_group = FILE_MODE_MAP[mode[4]]
    mode_other = FILE_MODE_MAP[mode[5]]
    link = format('%2d', stats.nlink)
    user_name = Etc.getpwuid(stats.uid).name
    group_name = Etc.getgrgid(stats.gid).name
    size = format('%4d', stats.size)
    mtime = stats.mtime
    month = format('%2d', mtime.month)
    day = format('%2d', mtime.day)
    time_or_year = format_time_or_year(mtime)
    [type + mode_owner + mode_group + mode_other, link, user_name, group_name, size, month, day, time_or_year, @file]
  end

  private

  def format_time_or_year(mtime)
    now = Time.now
    today = now.to_date
    if mtime.to_date >= today.prev_month(6) && mtime < now
      mtime.strftime('%H:%M')
    else
      format('%5d', mtime.strftime('%Y'))
    end
  end
end
