class Enemy_Controller < Sprite
  
  def initialize(delta_x, delta_y, list_of_enemies)
    super("blank.gif")
    
    #how many frames it should wait between moving
    @move_every = 15

    #distance from left/right when it should move down
    @buffer = 40
    
    #how far it shoud move every time
    @x_jump = delta_x
    @y_jump = delta_y
    
    @enemies = list_of_enemies 
    
    #used so it doesn't jump down multiple times in a row
    @just_jumped_y = false
    
    #starts the main move loop
    self.wait(@move_every) {self.move}
    
  end
  
  #called every @move_every frame
  #checks to see if the enemies are hitting the edge, and moves them down
  #else moves them all in the x direction
  def move
    
    #needs do something different if any single one of the enemies is
    #touching the edge
    hitting_side = self.is_hitting_side?
    
    #right after jumping y, it's still touching y. so we need to 
    #force it into jumping x
    if hitting_side && !@just_jumped_y
      self.jump_y(@y_jump)
      
      #make it go in the opposite direction and move to the other side
      @x_jump *= -1
      @just_jumped_y = true
    else
      @just_jumped_y = false
      self.jump_x(@x_jump)
    end
    
    #restart the move loop
    self.wait(@move_every) {self.move}
  end
  
  #checks to see if any of the visible enemies
  #are within buffer of the edge
  def is_hitting_side?
    @enemies.each do |enemy|
      if enemy.distance_from_left_right < @buffer and enemy.visible
        return true
      end
    end
    return false
  end
  
  #move everything delta in the x direction
  def jump_x(delta)
    @enemies.each do |enemy|
      if enemy.visible
        enemy.x = enemy.x + delta
      end
    end
  end
    
  #move everything delta in the y direction
  def jump_y(delta)
    @enemies.each do |enemy|
      if enemy.visible
        enemy.y = enemy.y + delta
      end
    end
  end
  
end