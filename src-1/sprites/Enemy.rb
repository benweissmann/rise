class Enemy < Sprite
  def initialize(x, y, player)
    super "rocker.gif"
    add_animation(:kill_animation, ["kill1.gif", "kill2.gif", "kill3.gif"], [10, 10, 10])
    @x = x
    @y = y
    @health = 2
    
    @player = player
    
    @speed = 4
    
    @original_x = @x
    @original_y = @y
    
    @side_length = 100
    @time_to_wait = 10
    @position_in_array = 0
    
    @attack_range = 100
    
    @chasing = false
    @chase_speed = 6.0
    
    @movement_array = [lambda{add_wait_until lambda{@x < @original_x - @side_length}, lambda{self.turn; @x_velocity = 0; wait(@time_to_wait) {@y_velocity = -@speed}}},
      lambda{add_wait_until lambda{@y < @original_y - @side_length}, lambda{self.turn; @y_velocity = 0; wait(@time_to_wait) {@x_velocity = @speed}}},
      lambda{add_wait_until lambda{@x > @original_x}, lambda{self.turn; @x_velocity = 0; wait(@time_to_wait) {@y_velocity = @speed}}},
      lambda{add_wait_until lambda{@y > @original_y}, lambda{self.turn; @y_velocity = 0; wait(@time_to_wait) {@x_velocity = -@speed}}}]
    
    @x_velocity = -@speed
    self.turn
#    self.add_image(:left, "Enemy_left.gif")
#    self.add_image(:right, "Enemy_right.gif")
#    self.add_image(:up, "Enemy_up.gif")
  end

  def collide_with_Weapon weapon
    @health = 0
    puts "dead"
  end

  def turn
    @movement_array[@position_in_array].call
    @position_in_array += 1
    if @position_in_array == @movement_array.length
      @position_in_array = 0
    end
  end
  
  def distance_from_player
    return Math.sqrt((@x-@player.x)**2+(@y-@player.y)**2)
  end
    
  def attack player
    self.move_towards(player)
  end
    
  def move_towards(player)
    delta_x = player.x - @x
    delta_y = player.y - @y
    
    chase_speed_over_distance = @chase_speed/self.distance_from_player
    
    @y_velocity = delta_y*chase_speed_over_distance
    @x_velocity = delta_x*chase_speed_over_distance
  end
    
  def pass_frame
    distance = distance_from_player
    
    if @health <= 0
      #puts "dead"
      play_animation :kill_animation
      wait 30 do
       EasyRubygame.active_scene.sprites.delete self
      end
    elsif distance < @attack_range
      self.attack(@player)
    elsif @chasing
      @chasing = false
      @x_original = @x
      @y_original = @y
      @position_in_array = 0
    end
 end
  #include Killable
 end