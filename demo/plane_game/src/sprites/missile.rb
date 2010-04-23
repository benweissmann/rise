# missile that drops down from top of screen
class Missile < Sprite
  # x: the x coordinate of the missile
  def initialize(x)
    # use missile image
    super("missile.gif")

    # set x and y. y is -10 so the missile starts just above the
    # top of the window.
    @x = x
    @y = -10

    # Accelerate downwards
    @y_acceleration = 2
  end

  # Each frame...
  def pass_frame
    # If this missile is offscreen, delete it from the active scene.
    if offscreen?
      EasyRubygame.active_scene.sprites.delete(self)
    end
  end
  
end
