# frozen_string_literal: true

##
# Main game class
class Game
  include Helpers

  include EventHandler
  include MainLoop
  include Render

  def initialize
    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::TTF.init

    @conf = Config.new({}).tap(&:load)
    @assets = Assets.new(@conf)

    @rs = RenderState.new(@conf)
  end

  def cleanup; end

  def run
    while @rs.active
      process_events
      main_loop
      render

      frame_info
    end

    cleanup
  end
end
