class Missile < Sprite
  def initialize(x)
    super("missile.gif")
    @x = x
    @y = -10
    @y_acceleration = 2
  end
  
  def pass_frame
    if offscreen?
      EasyRubygame.active_scene.sprites.delete(self)
    end
  end
  
end