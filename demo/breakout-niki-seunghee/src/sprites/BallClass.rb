# creating the class for the balls that will go around and destroy the block
class Ball < Sprite

  #initialize with a velocity (and a default picture and location)
  def initialize(xvel, yvel)
    super('ball.gif')
    @x = 250
    @y = 250
    @x_velocity = xvel
    @y_velocity = yvel

    @can_hit_block = true

  end

  #creating all the collide with methods. what happens when it gets to different
  #of the screen
  def collide_with_Paddle(paddle)
    @y_velocity = -@y_velocity
  end
  
  def pass_frame 
    @can_hit_block = true
  end

  def colliding_right_of_Block block
    if @can_hit_block
      puts "right"
      @x_velocity *= -1
      block.hide
      @can_hit_block = false
    end
  end
  
  def colliding_left_of_Block block
    if @can_hit_block
      puts "left"
      @x_velocity *= -1
      block.hide
      @can_hit_block = false
    end
  end
  
  def colliding_top_of_Block block
    if @can_hit_block
      puts "top"
      @y_velocity *= -1
      block.hide
      @can_hit_block = false
    end
  end
  
  def colliding_bottom_of_Block block
    if @can_hit_block
      puts "bottom"
      @y_velocity *= -1
      block.hide
      @can_hit_block = false
    end
  end

  def touch_right
    @x_velocity = -@x_velocity
  end

  def touch_left
    @x_velocity = -@x_velocity
  end

  def touch_top
     @y_velocity = -@y_velocity
  end

  def touch_bottom
      @y_velocity *= -1
  end

end
