# frozen_string_literal: true

##
# Main game class
class Game
  include EventHandler
  include Helpers

  def initialize
    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::TTF.init

    @conf = Config.new({}).tap(&:load)
    @assets = Assets.new(@conf)

    @rs = RenderState.new(@conf)
  end

  def process_events
    while (event = SDL2::Event.poll)
      handle(event)
    end
  end

  def main_loop; end

  def render
    # fill background
    bg_rect = SDL2::Rect[0, 0, *@rs.window.size]
    @rs.renderer.draw_color = [0, 0, 0]
    @rs.renderer.fill_rect(bg_rect)

    sample_text = mk_text(:sans_regular, :title, 'Hello, world!')

    r2 = SDL2::Rect[0, 0, sample_text.w, sample_text.h]

    @rs.renderer.copy(sample_text, nil, r2)

    @rs.renderer.present
  end

  def cleanup; end

  def frame_info
    @ticks ||= 0
    @frames ||= 0
    @frames += 1

    new_ticks = SDL2.get_performance_counter

    fps = new_ticks == @ticks ? 0 : (SDL2.get_performance_frequency / (new_ticks - @ticks))
    if @frames.multiple_of?(500)
      $stderr.printf("%9.2<fps>f FPS (frame %<frame>d, %15<ticks>d ticks)\n",
                     fps: fps, frame: @frames, ticks: new_ticks)
    end

    @ticks = new_ticks
  end

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
