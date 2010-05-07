module EasyRubygame
  # Represents a group of sprites.
  class Scene
    # An array of sprites that belong to this scene.
    attr_accessor :sprites
    
    # +background+ is an optional parameter that controls the
    # background of this scene.
    # - If it's a string, a file with that name will be loaded from
    #   resources/images and tiled to fill the background.
    # - If it represents a color (as an [r, g, b] array, the name
    #   of a color as a symbol, or any other format supported by
    #   EasyRubygame.to_color), that color will be used as the
    #   background.
    # - If it is omitted, it defaults to a white background.
    def initialize(background = :white)
      self.background = background
      @sprites = Sprites::Group.new
    end

    # Changes the background of this scene. See Scene.new for details
    # on how to specify a background.
    def background= bg
      @background = Surface.new(EasyRubygame.screen.size)

      if bg.kind_of? String
        image = Surface[bg]
        0.step EasyRubygame.window_width, image.w do |x|
          0.step EasyRubygame.window_height, image.h do |y|
            image.blit @background, [x, y]
          end
        end
      else
        @background.fill EasyRubygame.to_color(bg)
      end
    end
    
    # Draws each of the sprites to the scene.
    def draw event_queue #:nodoc:
      @sprites.update
    
      @background.blit EasyRubygame.screen, [0,0], nil
      @sprites.each do |sprite|
     	  sprite.draw(EasyRubygame.screen) if sprite.visible?
     	#  if sprite.instance_of? Ball
     	    #@background.draw_line_a([0,0], [100,100], [0,0,0])
     	   # x_y_diff = [[0, 0], [0, sprite.image_height/2.0], [0, sprite.image_height], [sprite.image_width/2.0, 0], [sprite.image_width/2.0, sprite.image_height], [sprite.image_width, 0], [sprite.image_width, sprite.image_height/2.0], [sprite.image_width, sprite.image_height]]
         # x_y_diff.each do |points|
         #   x = points[0]
         #   y = points[1]
         #   x = 0
          #  y = 0
            
          #  @background.draw_line_a([sprite.prev_x+x, sprite.prev_y+y],[sprite.x+x, sprite.y+y], [0,0,0])
          #end
     	  #end
      end
    end

    # Passes an event on to all sprites in this scene.
    def propagate_event event #:nodoc
      @sprites.call(:handle, event)
    end
  end
end
