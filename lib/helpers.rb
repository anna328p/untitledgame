# frozen_string_literal: true

##
# Various helper functions for the game
module Helpers
  def mk_text(font_type, size, text)
    surface = @assets.fonts[font_type][size].render_blended(text, [255, 255, 255])
    @rs.renderer.create_texture_from(surface)
  end
end
