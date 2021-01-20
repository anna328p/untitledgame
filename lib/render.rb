# frozen_string_literal: true

##
# Render the current game state
module Render
  def render
    fill_bg
    sample_text
    debug_text

    @rs.renderer.present
  end

  def debug_text
    ypos = 0
    @rs.debug_text.lines.each do |line|
      debug_text = mk_text(:mono_regular, :label, line.chomp)
      rect = SDL2::Rect[0, ypos, debug_text.w, debug_text.h]
      @rs.renderer.copy(debug_text, nil, rect)
      ypos += debug_text.h + 2
    end
    @rs.debug_text = ''
  end

  def sample_text
    sample_text = mk_text(:sans_regular, :title, 'Hello, world!')

    r2 = SDL2::Rect[@state.pos_x, @state.pos_y, sample_text.w, sample_text.h]

    @rs.renderer.copy(sample_text, nil, r2)
  end

  def fill_bg
    bg_rect = SDL2::Rect[0, 0, *@rs.window.size]
    @rs.renderer.draw_color = [0, 0, 0]
    @rs.renderer.fill_rect(bg_rect)
  end
end
