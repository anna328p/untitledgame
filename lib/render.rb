# frozen_string_literal: true

##
# Render the current game state
module Render
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
end
