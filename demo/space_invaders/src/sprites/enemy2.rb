require 'sprites/enemy'

class Enemy2 < Enemy
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy2a.gif", "enemy2b.gif")
    @explode_shift = 1
  end
end
