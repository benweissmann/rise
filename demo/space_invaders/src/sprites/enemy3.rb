class Enemy3 < Enemy
  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy3a.gif", "enemy3b.gif")
    
    @explode_shift = 1
  end
  
  #due to a bug with the magic methods and inheritance, 
  #this needs to be in all the subclasses
  #it's no different than the one in enemy.rb
  def collide_with_Player_Bullet(bullet)
    self.kill
    bullet.hide
    self.wait(@explode_timer) {self.hide}
  end
  
end