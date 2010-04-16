class Ship < Sprite
  
  def initialize start_x
    super('ship.gif')
    
    @x = start_x
    @y = 350
    
    @shooting = false
    @curr_bullet = nil
  end
  
  def key_pressed_left
    @x_velocity = -5
  end
  
  def key_released_left
    @x_velocity = 0
  end
  
  def key_pressed_right
    @x_velocity = 5
  end
  
  def key_released_right
    @x_velocity = 0
  end
  
  def key_pressed_space
    @shooting = true
  end
  
  def key_released_space
    @shooting = false
  end
  
  def pass_frame
    if @shooting && (@curr_bullet == nil || !@curr_bullet.visible)
      self.shoot
    end
  end
  
  def shoot
    @curr_bullet = Player_Bullet.new(@x+@rect.width/2-2, @y-3)
    EasyRubygame.active_scene.sprites.push(@curr_bullet)
  end
  
  def collide_with_Enemy_Bullet(bullet)
    self.kill
    bullet.hide
  end
  
end