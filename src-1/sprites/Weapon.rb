class Weapon < Sprite
  def initialize(player)
    super "sword_down.gif"
    @x = player.x + 10
    @y = player.y + 30
    @player = player

    self.hide

    self.add_image(:left, "sword_left.gif")
    self.add_image(:right, "sword_right.gif")
    self.add_image(:up, "sword.gif")
  end

  def key_pressed_left
    self.update_position
    self.change_image(:left)
  end

  def key_pressed_right
    self.update_position
    self.change_image(:right)
  end
 
  def key_pressed_up
    self.update_position
    self.change_image(:up)
  end
  
  def key_pressed_down 
    self.update_position
    self.change_image(:default)
  end
  
  def key_pressed_z
    self.update_position
    self.show
  end

  def key_released_z
    self.hide
  end

  def update_position
    if self.name == :default
      @x = @player.x + 10
      @y = @player.y + 30
    elsif self.name == :left
      @x = @player.x - 5
      @y = @player.y + 22
    elsif self.name == :right
      @x = @player.x + 25
      @y = @player.y + 22
    elsif self.name == :up
      @y = @player.y + 10
      @x = @player.x + 10
    end
  end

  def pass_frame
    self.update_position
  end

end