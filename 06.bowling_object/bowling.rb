#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

shots = ARGV[0]
game = Game.new(shots.split(','))
puts game.score
