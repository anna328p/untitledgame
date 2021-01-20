# frozen_string_literal: true

##
# Current state of the game controls
class ControlState
  attr_accessor :keys_down, :vel

  def initialize(conf)
    @conf = conf
    @keys_down = Set.new
    @vel = Vector[0, 0]
  end

  def get_key(name)
    if name == :esc
      @keys_down.include? SDL2::Key::ESCAPE
    else
      @keys_down.any? { @conf.keybinds[name].include? SDL2::Key.name_of(_1) }
    end
  end
end
