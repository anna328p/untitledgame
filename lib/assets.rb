# frozen_string_literal: true

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
