# frozen_string_literal: true

class BaseFormat
  def initialize(flags)
    @files = Dir.glob('*', flags)
  end

  def reverse
    raise NotImplementedError
  end

  def output
    raise NotImplementedError
  end
end
