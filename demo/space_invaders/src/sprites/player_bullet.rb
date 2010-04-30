require 'sprites/bullet'

class Player_Bullet < Bullet
  
  #very very similar to Enemy_Bullet - it just moves in a different direction
  #may make them have seperate images at some point
  def initialize(start_x, start_y)
    super('bullet.gif')
    
    @x = start_x
    @y = start_y
    
    @y_velocity = -10
    
  end
end
