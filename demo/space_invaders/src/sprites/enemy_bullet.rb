require 'sprites/bullet'

class Enemy_Bullet < Bullet
  
  #separated from player_bullet in case I wanted to
  #change the picture for the bullet
  def initialize(start_x, start_y)
    super('bullet.gif')

    @x = start_x
    @y = start_y

    @y_velocity = 10

  end
end
