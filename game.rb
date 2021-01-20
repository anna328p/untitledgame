#!/usr/bin/env ruby
# frozen_string_literal: true

Bundler.require(:default)
require 'yaml'
require 'fileutils'
require 'set'

%w[
  assets
  config
  render_state
  helpers
  event_handler
  movement
  game_state
  control_state
  main_loop
  render
  game
].each do |filename|
  require_relative "lib/#{filename}"
end

game = Game.new
game.run
