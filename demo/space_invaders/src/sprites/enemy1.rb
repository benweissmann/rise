class Enemy1 < Enemy
  
  def initialize(start_x, start_y)
    super(start_x, start_y, "enemy1a.gif", "enemy1b.gif")
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