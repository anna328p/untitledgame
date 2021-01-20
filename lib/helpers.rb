# frozen_string_literal: true

##
# Various helper functions for the game
module Helpers
  def mk_text(font_type, size, text)
    surface = @assets.fonts[font_type][size].render_blended(text, [255, 255, 255])
    @rs.renderer.create_texture_from(surface)
  end

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

end
