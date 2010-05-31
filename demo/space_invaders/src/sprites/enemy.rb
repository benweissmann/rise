class Enemy < Sprite
  
  def initialize(start_x, start_y, image_a, image_b)
    super(nil)
    
    #the enemy should alternate between two images: image_a, and image_b
    #this changes every time one sets a new x or y
    #death_image is shown when it's blown up
    self.add_image(:a, image_a)
    self.add_image(:b, image_b)
    self.add_image(:death_image, "enemy_death.gif")

    self.change_image(:a)

    #how long the death image should stay up
    @explode_timer = 10
    #sometimes the explosion needs to be shifted a little bit
    @explode_shift = 0
        
    @x = start_x
    @y = start_y
    
    #max time between firing two shots
    @max_bullet_delay = 1500
    
    #main shooting lop
    self.wait(rand(@max_bullet_delay)) do
      self.shoot
    end
  end
  
  #we want the image to change every time the enemy moves
  #so I inherited from the attr_accessor method to switch the image
  def x=(new_x)
    self.switch_image
    super(new_x)
  end
  
  def y=(new_y)
    self.switch_image
    super(new_y)
  end
  
  #if we aren't dead yet, change to the other image
  def switch_image
    if self.name != :death_image
      if self.name == :a
        self.change_image(:b)
      elsif self.name == :b
        self.change_image(:a)
      end
    end
  end

  #oh no, I'm dead! I should explode, taking the bullet with me.
  #then I'll dissapear as well...
  def collide_with_Player_Bullet(bullet)
    self.kill
    bullet.hide
    self.wait(@explode_timer) {self.hide}
  end

  def shoot
  #if I'm not dead, add a bullet to the active scene
    if(self.name != :death_image)
      RISE.active_scene.sprites.push(Enemy_Bullet.new(@x+@rect.width/2-2, @y+2))
      #then fire again
      self.wait(rand(@max_bullet_delay)) {self.shoot}
    end 
  end
  
  def kill
    #change the image to death
    self.change_image(:death_image)
    #and move a little bit to make everything line up
    @x -= @explode_shift
    #will eventually also increase points – we need to add
    #a feature to ERG first
  end
end