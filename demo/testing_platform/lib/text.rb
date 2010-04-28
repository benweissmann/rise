module EasyRubygame
  class TextSprite < Sprite
    FONT_DIR = RESOURCE_DIR + 'fonts/'

    attr_accessor :font, :size, :color, :bg_color, :text
    
    def initialize config
      super(nil)
      @old_specs = []
      @font = config[:font] || 'sans.ttf'
      @size = config[:size] || 12
      @text = config[:text] || '' 
      
      @color = if config[:color]
        EasyRubygame.to_color(config[:color])
      else
        Color[:black]
      end
      
      @bg_color = if config[:bg_color]
        EasyRubygame.to_color(config[:bg_color])
      else
        nil
      end
      
      @x = config[:x] || 0
      @y = config[:y] || 0

      update_surface
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
      @color = EasyRubygame.to_color @color
      @bg_color = EasyRubygame.to_color @bg_color unless @bg_color.nil?
      self.surface = @ttf.render @text, true, @color, @bg_color
    end
  end
end

TTF.setup
