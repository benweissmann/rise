class Enemy_Bullet < Bullet
  def initialize(start_x, start_y)
    super('bullet.gif')

    @x = start_x
    @y = start_y

    @y_velocity = 10

  end
end