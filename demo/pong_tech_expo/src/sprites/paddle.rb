class Paddle < Sprite
  def initialize(x)
    super("paddle.gif")
    @x = x
    @y = 200
  end

end

class Paddle_left < Paddle
  def key_pressed_a
    @y_velocity = -10
  end
  def key_released_a
    @y_velocity = 0
  end
  def key_pressed_z
    @y_velocity = 10
  end
  def key_released_z
    @y_velocity = 0
  end
end

class Paddle_right < Paddle
  def key_pressed_k
    @y_velocity = -10
  end
  def key_released_k
    @y_velocity = 0
  end
  def key_pressed_m
    @y_velocity = 10
  end
  def key_released_m
    @y_velocity = 0
  end
end
