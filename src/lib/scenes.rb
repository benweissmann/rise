module EasyRubygame
  class Scene
    attr_accessor :sprites
    
    def initialize
      @sprites = Sprites::Group.new
      @background = Surface.new(EasyRubygame.screen.size)
      @background.fill([250,250,250])
    end

    def draw event_queue
      event_queue.each do |event|
        @sprites.call(:handle, event)
		  end

      @sprites.update

      @background.blit EasyRubygame.screen, [0,0]
      @sprites.draw EasyRubygame.screen
    end
  end
end
