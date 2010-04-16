module EasyRubygame
  class TextSprite < Sprite
    FONT_DIR = RESOURCE_DIR + 'fonts/'

    attr_accessor :font, :size, :color, :bg_color, :text
    
    def initialize config
      @old_specs = []
      @font = config[:font] || 'sans.ttf'
      @size = config[:size] || 12
      @text = config[:text] || '' 
      @color = config[:color] || [0, 0, 0]
      @bg_color = config[:bg_color] || [0, 0, 0]
      @x = config[:x] || 0
      @y = config[:y] || 0
    end

    def update
      super()
      unless @old_specs == [@font, @size, @color, @bg_color, @text]
        update_surface
        @old_specs == [@font, @size, @color, @bg_color, @text]
      end
    end

    def update_surface
      file = TextSprite::FONT_DIR + font
      @ttf = TTF.new file, size
      self.surface = @ttf.render @text, false, @color, @bg_color
    end
  end
end
