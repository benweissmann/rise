class Enemy1 < Enemy
  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy1a.gif", "enemy1b.gif")
  end
  
  def collide_with_Player_Bullet(bullet)
    if(@explode_timer == @explode_timer_original)
      self.kill
      bullet.hide
      @explode_timer -= 1
    end
  end
  
end