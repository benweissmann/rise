module EasyRubygame
  # EasyRubygame's base sprite class
  class Sprite
    # include the Rubygame Sprite module
    include Sprites::Sprite
    include EventHandler::HasEventHandler

    def initialize
      super()
    end
  end
end