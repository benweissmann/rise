module RISE
  class TextSprite < Sprite
    FONT_DIR = RESOURCE_DIR + 'fonts/'

    # The font file in resources/fonts/ that the text will be
    # rendered with.
    attr_accessor :font

    # The size, in points, of the text.
    attr_accessor :size

    # The color of the text. This can be an [r, g, b] color array,
    # the name of a color as a symbol, or any other format supported
    # by RISE.to_color.
    attr_accessor :color

    # The background color drawn behind the text. This can be an
    # [r, g, b] color array,  the name of a color as a symbol, or
    # any other format supported by RISE.to_color.
    #
    # If +bg_color+ is nil, the text will be drawn with a transparent
    # background.
    attr_accessor :bg_color

    # The text that will be rendered.
    attr_accessor :text

    # +config+ is hash that can contain values for any of TextSprites
    # attributes.
    def initialize config
      super(nil)
      @old_specs = []
      @font = config[:font] || 'sans.ttf'
      @size = config[:size] || 12
      @text = config[:text] || '' 
      
      @color = if config[:color]
        RISE.to_color(config[:color])
      else
        Color[:black]
      end
      
      @bg_color = if config[:bg_color]
        RISE.to_color(config[:bg_color])
      else
        nil
      end
      
      @x = config[:x] || 0
      @y = config[:y] || 0

      update_surface
    end

    def update #:nodoc:
      super()
      unless @old_specs == [@font, @size, @color, @bg_color, @text]
        update_surface
        @old_specs == [@font, @size, @color, @bg_color, @text]
      end
    end

    # Renders text onto @surface
    def update_surface #:nodoc:
      file = TextSprite::FONT_DIR + font
      @ttf = TTF.new file, size
      @color = RISE.to_color @color
      @bg_color = RISE.to_color @bg_color unless @bg_color.nil?
      self.surface = @ttf.render @text, true, @color, @bg_color
    end
  end
end
