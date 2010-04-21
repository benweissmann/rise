class BouncyText < TextSprite
  def initialize text
    super({:text => text, :size => 20})
    @y_velocity = @x_velocity = 2
    @y = 100
    @x = 150
  end

  def touch_top
    switch_color
    @y_velocity = -@y_velocity
  end

  def touch_bottom
    switch_color
    @y_velocity = -@y_velocity
  end

  def touch_left
    switch_color
    @x_velocity = -@x_velocity
  end

  def touch_right
    switch_color
    @x_velocity = -@x_velocity
  end

  def switch_color
    @color = [rand(251), rand(251), rand(251)]
  end
end
