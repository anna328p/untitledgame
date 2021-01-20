# frozen_string_literal: true

##
# Game's running state
class RenderState
  attr_accessor :active, :window

  def initialize(conf)
    @conf = conf

    init_window
    @active = true
  end

  def init_window
    window_flags =
      SDL2::Window::Flags::OPENGL

    @window = SDL2::Window.create(
      'Untitled Game',
      100, 100,
      @conf.resolution.width, @conf.resolution.height,
      window_flags
    )
  end

  def renderer
    @renderer ||= (@window.renderer || @window.create_renderer(-1, 0))
  end
end
