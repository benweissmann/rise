class Enemy1 < Enemy
  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy1a.gif", "enemy1b.gif")
  end


  def collide_with_Player_Bullet(bullet)
    self.kill
    bullet.hide
    self.wait(@explode_timer) {self.hide}
  end

end