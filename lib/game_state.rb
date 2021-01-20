# frozen_string_literal: true

##
# User-facing state of the game. This is what gets saved

class GameState
  attr_accessor :pos_x, :pos_y

  def initialize
    @pos_x = @pos_y = 0
  end
end
