class Ball < Sprite
  def initialize(x, y, x_vel, y_vel)
    super("ball.gif")
    @x = x
    @y = y
    @x_velocity = x_vel
    @y_velocity = y_vel
  end
  def touch_top
    @y_velocity *= -1
  end
  def touch_bottom
    @y_velocity *= -1
  end
  def touch_left
    puts "right player wins!"
    exit
  end
  def touch_right
    puts "left player wins!"
    exit
  end
  def collide_with_Paddle paddle
    @x_velocity *= -1
  end
end