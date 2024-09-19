# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  ALL_PINS = 10

  def strike?
    @first_shot.score == ALL_PINS
  end

  def spare?
    @first_shot.score != ALL_PINS && [@first_shot.score, @second_shot.score].sum == ALL_PINS
  end
end
