# frozen_string_literal: true

require_relative 'status'
require_relative 'base_format'

class LongFormat < BaseFormat
  def initialize(flags)
    super(flags)
    @stats = @files.map { |file| Status.new(file) }
  end

  def reverse
    @files.reverse!
    @stats.reverse!
    self
  end

  def output
    total_blocks = @files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"
    @stats.each do |stat|
      puts stat.list.join(' ')
    end
  end
end
