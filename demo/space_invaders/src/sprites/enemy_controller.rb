class Array
  def sum
    to_return = 0
    self.each {|item| to_return += item}
    return to_return
  end
end

class Enemy_Controller < Sprite
  
  def initialize(delta_x, delta_y, list_of_enemies)
    super("blank.gif")
    
    @move_every = 15

    @buffer = 40
    @x_jump = delta_x
    @y_jump = delta_y
    @enemies = list_of_enemies 
    
    @just_jumped_y = false
    
    self.wait(@move_every) {self.move}
    
  end
  
  def move
    hitting_side = false
    @enemies.each do |enemy|
      if enemy.distance_from_left_right < @buffer and enemy.visible
        hitting_side = true
        break
      end
    end
    
    if hitting_side && !@just_jumped_y
      self.jump_y(@y_jump)
      @x_jump *= -1
      @just_jumped_y = true
    else
      @just_jumped_y = false
      self.jump_x(@x_jump)
    end
    
    self.wait(@move_every) {self.move}
  end
  
  def jump_x(delta)
    @enemies.each do |enemy|
      if enemy.visible
        enemy.x = enemy.x + delta
      end
    end
  end
    
  def jump_y(delta)
    @enemies.each do |enemy|
      if enemy.visible
        enemy.y = enemy.y + delta
      end
    end
  end
  
end