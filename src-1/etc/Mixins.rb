module Killable
  attr_accessor :num_hits_to_kill, :health

  def set_up
    add_animation(:kill_animation, ["kill1.gif", "kill2.gif", "kill3.gif"], [10,10,10])
    @health = @num_hits_to_kill
  end

  def collides_with_Weapon weapon
    @health = @health - weapon.strength
  end

  def pass_frame
    if @health <= 0
    play_animation :kill_animation
    EasyRubygame.active_scene.sprites.delete self
    end
  end

end

module Equiptable
  def set_up
    weapons_array.push(self)
  end

  def pass_frame
    if @selected == true
    player.active_weapon = self
    end
  end

end

