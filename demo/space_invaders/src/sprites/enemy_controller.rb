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
    
    @move_every_original = 15
    @move_every = @move_every_original

    @buffer = 20
    @x_jump = delta_x
    @y_jump = delta_y
    @enemies = list_of_enemies 
    
    @just_jumped_y = false
    
  end
  
  def pass_frame
    
    hitting_side = false
    @enemies.each do |enemy|
      if enemy.distance_from_left_right < @buffer and enemy.visible
        hitting_side = true
        break
      end
    end
    
    @enemies.each do |enemy|
      if enemy.visible && rand(3000) == 1
        enemy.shoot
      end
    end
    
    if @move_every <= 0
      
      if hitting_side && !@just_jumped_y
        self.jump_y(@y_jump)
        @x_jump *= -1
        @just_jumped_y = true
      else
        @just_jumped_y = false
        self.jump_x(@x_jump)
      end
      @move_every = @move_every_original
    else
      @move_every -= 1
    end
    
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