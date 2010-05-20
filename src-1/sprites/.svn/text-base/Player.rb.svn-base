class Player < Sprite
  attr_accessor :health, :active_weapon

  attr_reader :x

  def initialize
    super "Player_down.gif"
    self.add_image(:left, "Player_left.gif")
    self.add_image(:right, "Player_right.gif")
    self.add_image(:up, "Player_up.gif")
#    Sounds.add(:bad_romance, "BadRomance.wav")
#    Sounds.play(:bad_romance)


    @active_weapon = nil

    @health = 9
    @x = 200
    @y = 200
  end

  def key_pressed_left
    

    
    self.change_image(:left)
    @x_velocity = -7
  end
  def key_released_left
    @x_velocity=0
  end
  def key_pressed_right
    self.change_image(:right)
    @x_velocity = 7
  end
  def key_released_right
    @x_velocity=0
  end

  def key_pressed_up
    self.change_image(:up)
    @y_velocity = -7
  end
  def key_released_up
    @y_velocity=0
  end

  def key_pressed_down
    self.change_image(:default)
    @y_velocity = 7
  end
  def key_released_down
    @y_velocity=0
  end

  def touch_top
    case EasyRubygame.active_scene.name
    when :crossroads
      change_scene(:green_r_d)
      @x = 50
      @y = 450
    when :grey_u_l
      change_scene(:crossroads)
      @x = 200
      @y = 450
    else
      @y = @y + 10
    end
     
  end

  def touch_left
    case EasyRubygame.active_scene.name
    when :crossroads
      change_scene(:red_r_d)
      @y = 200
      @x = 450
    when :blue_l_d
      change_scene(:crossroads)
      @y = 200
      @x = 450
    when :green_l_d_r
      change_scene(:green_r_d)
      @y = 200
      @x = 450
    when :grey_u_l
      change_scene(:crossroads)
      @y = 200
      @x = 450
    else
      @x = @x + 10
    end
  end

  def touch_right
    case EasyRubygame.active_scene.name
    when :crossroads
      change_scene(:blue_l_d)
      @y = 200
      @x = 10
    when :red_r_d
      change_scene(:crossroads)
      @y = 200
      @x = 10
    when :green_l_d_r
      change_scene(:crossroads)
      @y = 200
      @x = 10
    when :green_r_d
      change_scene(:green_l_d_r)
      @y = 200
      @x = 10
    else
      @x = @x - 10
    end
  end

  def touch_bottom
    case EasyRubygame.active_scene.name
    when :crossroads
      change_scene(:grey_u_l)
      @x = 200
      @y = 10
    when :red_r_d
      change_scene(:crossroads)
      @x = 200
      @y = 10
    when :blue_l_d
      change_scene(:crossroads)
      @x = 200
      @y = 10
    when :green_r_d
      change_scene(:crossroads)
      @x = 200
      @y = 10
    when :green_l_d_r
      change_scene(:crossroads)
      @x = 200
      @y = 10
    else
      @y = @y - 10
    end
  end

  def change_scene(name)
    EasyRubygame.active_scene = EasyRubygame.storage[name]
  end

end

  