class AutoPaddle < Sprite
  def initialize(ball, x)
    super('paddle.png')
    @ball = ball
    @x = x
    @y = ball.y - 25
  end

  def pass_frame
    @y = @ball.y - 25
  end
end