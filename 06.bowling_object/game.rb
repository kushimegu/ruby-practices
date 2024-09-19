# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = shots
  end

  def score
    total_score = 0
    @frames = sort_by_frames.map { |frame| Frame.new(*frame) }
    @frames.each_with_index do |frame, i|
      total_score += frame.score
      break if i == 9

      total_score += calculate_bonus_score(frame, i)
    end
    total_score
  end

  def sort_by_frames
    frames = []
    frame = []
    @shots.each do |shot|
      frame << shot
      next if (frames.length == 9) || (frame.length == 1 && frame != ['X'])

      frames << frame
      frame = []
    end
    frames << frame
    frames
  end

  def calculate_bonus_score(frame, index)
    if frame.strike?
      if @frames[index + 1].strike?
        10 + (@frames[index + 2] ? @frames[index + 2].first_shot.score : @frames[index + 1].second_shot.score)
      else
        @frames[index + 1].first_shot.score + @frames[index + 1].second_shot.score
      end
    elsif frame.spare?
      @frames[index + 1].first_shot.score
    else
      0
    end
  end
end