require 'sprites/enemy'

class Enemy1 < Enemy  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy1a.gif", "enemy1b.gif")
  end
end
