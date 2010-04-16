class Enemy2 < Enemy
  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy2a.gif", "enemy2b.gif")
    @explode_shift = 1
  end

  def collide_with_Player_Bullet(bullet)
    self.kill
    bullet.hide
    self.wait(@explode_timer) {self.hide}
  end

end