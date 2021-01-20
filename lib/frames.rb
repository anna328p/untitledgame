# frozen_string_literal: true

##
# Frame limiting and interpolation
module Frames
  TARGET_FPS = 60

  def ticks_left
    ticks_per_frame - (cur_ticks - @ticks)
  end

  def ticks_per_frame
    tps / TARGET_FPS
  end

  def ticks_per_ms
    tps / 1000.0
  end

  def tps
    @tps ||= SDL2.get_performance_frequency
  end

  def cur_ticks
    SDL2.get_performance_counter
  end

  def frame_limit
    @frames ||= 0
    @frames += 1

    target = cur_ticks + ticks_left
    until cur_ticks >= target; end

    debug_fps
  end

  def debug_fps
    elapsed = cur_ticks - @ticks
    fps = tps / elapsed

    @rs.debug_text += format(
      "fps %9.2<fps>f (%6.2<ftime>f ms)\n",
      fps: fps, ftime: elapsed / ticks_per_ms
    )
  end
end
