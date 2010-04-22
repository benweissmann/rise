class Ship < Sprite
  
  def initialize start_x
    super('ship.gif')
    
    @x = start_x
    @y = 350
    
    #I can't shoot until my last bullet is gone. so 
    #I need to keep track of it I want to shoot, and
    #where my last shot is
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
  
  #I want to be able to hold down space to shoot, so I do this
  def key_pressed_space
    @shooting = true
  end
  
  def key_released_space
    @shooting = false
  end
  
  def pass_frame
    #if it's time to shoot again, then I will
    if @shooting && (@curr_bullet == nil || !@curr_bullet.visible)
      self.shoot
    end
  end
  
  def shoot
    #position correction due to location being measured from the top left
    @curr_bullet = Player_Bullet.new(@x+@rect.width/2-2, @y-3)
    EasyRubygame.active_scene.sprites.push(@curr_bullet)
  end
  
  #killing my self
  def collide_with_Enemy_Bullet(bullet)
    self.kill
    bullet.hide
    #will eventually cause you to just loose a life
  end
  
end