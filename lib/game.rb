# frozen_string_literal: true

##
# Main game class
class Game
  include Helpers

  include EventHandler
  include MainLoop
  include Frames
  include Render

  def initialize
    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::TTF.init

    @conf = Config.new({}).tap(&:load)
    @assets = Assets.new(@conf)

    @rs = RenderState.new(@conf)
    @cs = ControlState.new(@conf)
    @state = GameState.new

    @frames = 0
  end

  def cleanup; end

  def run
    @ticks ||= 0

    while @rs.active
      @ticks = cur_ticks
      process_events
      main_loop
      render

      frame_limit # unless @rs.vsync
    end

    cleanup
  end
end
