class Plane < Sprite
  def initialize(x, y)
    super("plane_top.gif")
    
    self.add_image(:left, "plane_left.gif")
    self.add_image(:right, "plane_right.gif")
    
    self.add_image(:explode1, "explode1.gif")
    self.add_image(:explode2, "explode2.gif")
    self.add_image(:explode3, "explode3.gif")
    
    @y = y
    @x = x
    @velocity_mag = 10
    
    @dead = false
  end
  
  def key_pressed_left
    if !@dead
      self.change_image(:left)
      @x_velocity = -@velocity_mag
    end
  end
  
  def key_released_left
    if !@dead
      self.change_image(:default)
      @x_velocity = 0
    end
  end
  
  def key_pressed_right
    if !@dead
      self.change_image(:right)    
      @x_velocity = @velocity_mag
    end
  end
  
  def key_released_right
    if !@dead
      self.change_image(:default)
      @x_velocity = 0
    end
  end
  
  def key_pressed_up
    if !@dead
      @y_velocity = -@velocity_mag
    end
  end
  
  def key_released_up
    if !@dead
      @y_velocity = 0
    end
  end
  
  def key_pressed_down
    if !@dead
      @y_velocity = @velocity_mag
    end
  end
  
  def key_released_down
    if !@dead
      @y_velocity = 0
    end
  end
  
  def collide_with_Missile missile
    @x_velocity = 0
    @y_velocity = 0
    
    missile.hide
    @dead = true
    
    self.change_image(:explode1)
    
     self.wait(7) do
        self.change_image(:explode2)
        self.wait(7) do
          self.change_image(:explode3)
          self.wait(7) do
            self.hide
            self.wait(15) do
              exit
            end
          end
        end
      end
    
  end
  
end