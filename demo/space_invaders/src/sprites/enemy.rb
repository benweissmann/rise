class Enemy < Sprite
  
  def initialize(start_x, start_y, image_a, image_b)
    super(image_a)
    
    self.add_image(:a, image_a)
    self.add_image(:b, image_b)
    self.add_image(:death_image, "enemy_death.gif")

    self.change_image(:a)

    @explode_timer = 10
    @explode_shift = 0
        
    @x = start_x
    @y = start_y
    
    @max_bullet_delay = 1500
    
    self.wait(rand(@max_bullet_delay)) do
      self.shoot
    end
  end
  
  def x=(new_x)
    self.switch_image
    super(new_x)
  end
  
  def y=(new_y)
    self.switch_image
    super(new_y)
  end
  
  def switch_image
    if self.name != :death_image
      if self.name == :a
        self.change_image(:b)
      elsif self.name == :b
        self.change_image(:a)
      end
    end
  end

  def collide_with_Player_Bullet(bullet)
    self.kill
    bullet.hide
    self.wait(@explode_timer) {self.hide}
  end

  def shoot
    if(self.name != :death_image)
      EasyRubygame.active_scene.sprites.push(Enemy_Bullet.new(@x+@rect.width/2-2, @y+2))
    end 
    self.wait(rand(@max_bullet_delay)) {self.shoot}
  end
  
  def kill
    self.change_image(:death_image)
    @x -= @explode_shift
    #will eventually also increase points
  end
end