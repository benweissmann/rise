# Player-controlled plane that dodges missiles
class Plane < Sprite
  # The speed this plane moves. Defaults to 10.
  attr_accessor :speed

  # x, y: starting coordinates of plane.
  def initialize(x, y)
    # the default plane image
    super("plane_top.gif")

    # add left and right banking images
    self.add_image(:left, "plane_left.gif")
    self.add_image(:right, "plane_right.gif")

    # add explosion animation
    self.add_animation(:explode, ["explode1.gif", "explode2.gif", "explode3.gif"], [7,7,7])

    # set x and y coordinates
    @y = y
    @x = x

    # set default speed.
    @speed = 10

    # I'm not dead yet!
    @dead = false
  end
  
  def key_pressed_left
    # "unless" is the opposite of if.
    # It's the same as saying "if not"
    unless @dead
      # set the image to the left bank
      self.change_image(:left)
      # move left
      @x_velocity = -@speed
    end
  end
  
  def key_released_left
    unless @dead
      self.change_image(:default)
      @x_velocity = 0
    end
  end
  
  def key_pressed_right
    unless @dead
      self.change_image(:right)    
      @x_velocity = @speed
    end
  end
  
  def key_released_right
    unless @dead
      self.change_image(:default)
      @x_velocity = 0
    end
  end
  
  def key_pressed_up
    unless @dead
      @y_velocity = -@velocity_mag
    end
  end
  
  def key_released_up
    unless @dead
      @y_velocity = 0
    end
  end
  
  def key_pressed_down
    if !@dead
      @y_velocity = @velocity_mag
    end
  end
  
  def key_released_down
    unless @dead
      @y_velocity = 0
    end
  end

  # when it's hit with a missile
  def collide_with_Missile missile
    unless @dead
      # stop moving
      @x_velocity = 0
      @y_velocity = 0

      # go away, missile
      missile.hide

      # die
      @dead = true

      # blow up
      self.play_animation(:explode)

      # wait until the explosion is done...
      self.wait(21) do
        # then dissapear
        self.hide

        # wait a few frames, then exit
        self.wait(15) do
          exit
        end
      end
    end
  end
  
end
