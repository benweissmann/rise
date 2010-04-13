class Enemy < Sprite
  
  def initialize(start_x, start_y, image_loc)
    super(image_loc)
    
    @curr_image = image_loc
    @image_a = image_loc
    @image_b = image_loc
    
    @death_image = "enemy_death.gif"
    @explode_timer_original = 10
    @explode_timer = @explode_timer_original
    @explode_shift = 0
        
    @x = start_x
    @y = start_y
    

  end
  
  def pass_frame
    if @explode_timer_original != @explode_timer
      if @explode_timer == 0
        self.hide
      else
        @explode_timer -= 1
      end
    end
  end
  
  def x=(new_x)
    self.change_image
    super(new_x)
  end
  
  def y=(new_y)
    self.change_image
    super(new_y)
  end
  
  def change_image
    if @curr_image == @death_image
      
    elsif @curr_image == @image_a
      @curr_image = @image_b
    else
      @curr_image = @image_a
    end
    self.image = @curr_image
  end
  
  def shoot
    if(@explode_timer == @explode_timer_original)
      EasyRubygame.active_scene.sprites.push(Enemy_Bullet.new(@x+@rect.width/2-2, @y+2))
    end
  end
  
  def kill
    @curr_image = @death_image
    self.image = @curr_image
    @x -= @explode_shift
    #self.hide
    #will eventually also increase points
  end
end