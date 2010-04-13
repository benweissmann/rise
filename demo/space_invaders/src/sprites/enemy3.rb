class Enemy3 < Enemy
  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy3a.gif")
    
    @image_b = "enemy3b.gif"
    @explode_shift = 1
  end
  
  def collide_with_Player_Bullet(bullet)
    if(@explode_timer == @explode_timer_original)
      self.kill
      bullet.hide
      @explode_timer -= 1
    end
  end
  
end