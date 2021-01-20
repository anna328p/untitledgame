#!/usr/bin/env ruby
# frozen_string_literal: true

Bundler.require(:default)
require 'yaml'
require 'fileutils'

%w[
  assets
  config
  event_handler
  render_state
  helpers
  game_state
  main_loop
  render
  game
].each do |filename|
  require_relative "lib/#{filename}"
end

game = Game.new
game.run
