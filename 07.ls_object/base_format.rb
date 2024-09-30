# frozen_string_literal: true

class BaseFormat
  def initialize(flags)
    @files = Dir.glob('*', flags)
  end

  def reverse
    @files.reverse!
    self
  end
end
