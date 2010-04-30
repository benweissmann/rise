require 'sprites/enemy'

class Enemy3 < Enemy 
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy3a.gif", "enemy3b.gif")
    
    @explode_shift = 1
  end
end
