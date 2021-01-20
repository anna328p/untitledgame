#!/usr/bin/env ruby
# frozen_string_literal: true

Bundler.require(:default)
require 'yaml'
require 'fileutils'

class State
  attr_accessor :active, :window, :renderer
end

Assets = Struct.new(
  :fonts
)

# Main game class
class Game
  def write_default_conf(path)
    default_conf = {
      resolution: {
        width: 800,
        height: 600
      },
      fonts: {
        mono_regular: 'SourceCodePro-Regular.ttf',
        mono_bold:    'SourceCodePro-Bold.ttf',
        sans_regular: 'SourceSans3-Regular.ttf',
        sans_bold:    'SourceSans3-Bold.ttf',
        sans_italic:  'SourceSans3-It.ttf'
      }
    }

    File.write(path, YAML.dump(default_conf))
  end

  def load_assets
    asset_path = @conf.asset_path || './assets'

    @assets = Assets.new

    @assets.fonts = @conf.fonts.each.map do |type, filename|
      [
        type,
        SDL2::TTF.open(File.join(asset_path, 'fonts', filename), 16)
      ]
    end.to_h

    p @assets.fonts
  end

  def load_config
    conf_dir = SDL2.preference_path('inexcomp', 'untitledgame')
    FileUtils.mkdir_p(conf_dir)

    config_path = File.join(conf_dir, 'config.yml')

    File.delete(config_path) if File.exist?(config_path)

    write_default_conf(config_path) unless File.exist?(config_path)

    @conf = (YAML.load_file(config_path) || {}).to_hashugar
  end

  def init_window
    window_flags =
      SDL2::Window::Flags::OPENGL

    SDL2::Window.create(
      'Untitled Game',
      100, 100,
      @conf.resolution.width, @conf.resolution.height,
      window_flags
    )
  end

  def mk_renderer
    @state.renderer ||= @state.window.renderer || @state.window.create_renderer(-1, 0)
  end

  def init
    load_config
    @state = State.new

    SDL2.init(SDL2::INIT_EVERYTHING)
    SDL2::TTF.init

    load_assets

    @state.window = init_window
    @state.renderer = mk_renderer

    @state.active = true
  end

  def process_events
    while (event = SDL2::Event.poll)
      puts event.inspect
      if event.instance_of?(SDL2::Event::Quit)
        @state.window.destroy
        @state.active = false
      end
    end
  end

  def main_loop; end

  def mk_text(font_type, text)
    surface = @assets.fonts[font_type].render_blended(text, [255, 255, 255])
    mk_renderer.create_texture_from(surface)
  end

  def render
    # fill background
    bg_rect = SDL2::Rect[0, 0, *@state.window.size]
    mk_renderer.draw_color = [0, 0, 0]
    mk_renderer.fill_rect(bg_rect)

    sample_text = mk_text(:sans_regular, 'Hello, world!')

    r2 = SDL2::Rect[0, 0, sample_text.w, sample_text.h]

    mk_renderer.copy(sample_text, nil, r2)

    mk_renderer.present
  end

  def cleanup; end

  def run
    tps = SDL2.get_performance_frequency
    ticks = 0
    new_ticks = 0

    frame_counter = 0

    while @state.active
      ticks = new_ticks
      process_events
      main_loop
      render

      frame_counter += 1
      new_ticks = SDL2.get_performance_counter
      diff = new_ticks - ticks
      fps = tps / (diff.zero? ? 1 : diff)
      if frame_counter % 500 == 0
        STDERR.puts("%9.2f FPS (frame %d, %15d ticks)" % [fps, frame_counter, new_ticks])
      end
    end

    cleanup
  end
end

game = Game.new
game.init
game.run
