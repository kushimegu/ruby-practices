# frozen_string_literal: true

require 'optparse'
require_relative 'short_format'
require_relative 'long_format'

class Command
  def initialize(command_text)
    options = command_text.getopts('arl')
    flags = options['a'] ? File::FNM_DOTMATCH : 0
    format_class = options['l'] ? LongFormat : ShortFormat
    @matrix = format_class.new(flags)
    @matrix.reverse if options['r']
  end

  def display
    @matrix.output
  end
end
