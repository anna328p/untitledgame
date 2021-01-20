#!/usr/bin/env ruby
# frozen_string_literal: true

Bundler.require(:default)
require 'yaml'
require 'fileutils'

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

##
# User-facing state of the game. This is what gets saved

class GameState; end

##
# Game configuration
class Config < Hashugar
  def load
    conf_dir = SDL2.preference_path('inexcomp', 'untitledgame')
    FileUtils.mkdir_p(conf_dir)

    config_path = File.join(conf_dir, 'config.yml')

    Config.write_default(config_path) # unless File.exist?(config_path)

    initialize(YAML.load_file(config_path) || {})
  end

  # rubocop: disable Metrics/MethodLength
  def self.write_default(path)
    default_conf = {
      resolution: {
        width: 800,
        height: 600
      },
      font_sizes: {
        label: 12,
        text: 16,
        header: 24,
        title: 36
      },
      fonts: {
        mono_regular: 'SourceCodePro-Regular.ttf',
        mono_bold: 'SourceCodePro-Bold.ttf',
        sans_regular: 'SourceSans3-Regular.ttf',
        sans_bold: 'SourceSans3-Bold.ttf',
        sans_italic: 'SourceSans3-It.ttf'
      }
    }

    File.write(path, YAML.dump(default_conf))
  end
  # rubocop: enable Metrics/MethodLength
end

##
# All of the assets
class Assets
  attr_accessor :fonts

  def initialize(conf)
    @conf = conf

    @base_path = @conf.asset_path || './assets'

    init_fonts
  end

  def init_fonts
    @fonts = {}
    @conf.font_sizes.each do |szname, ptsize|
      @conf.fonts.each.to_h.each do |type, filename|
        fonts[type] ||= {}
        fonts[type][szname] = SDL2::TTF.open(File.join(@base_path, 'fonts', filename), ptsize)
      end
    end
  end
end

module EventHandler
  def handle(event)
    warn event.inspect
    case event
    when SDL2::Event::Quit
      quit_event
    end
  end

  def quit_event
    p @rs
    @rs.window.destroy
    @rs.active = false
  end
end

# Main game class
class Game
  include EventHandler

  def init
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

  def mk_text(font_type, size, text)
    surface = @assets.fonts[font_type][size].render_blended(text, [255, 255, 255])
    @rs.renderer.create_texture_from(surface)
  end

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

game = Game.new
game.init
game.run
