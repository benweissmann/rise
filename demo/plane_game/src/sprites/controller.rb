class Controller < Sprite
  
  def initialize()
    super("blank.gif")
    @ball_occurance = 60
    self.wait(rand(@ball_occurance)) do
      self.drop_ball
    end
  end
  
  def drop_ball
      EasyRubygame.active_scene.sprites.push(Missile.new(rand(EasyRubygame.window_width)))   
   
      self.wait(rand(@ball_occurance)) do
        self.drop_ball
      end
  end
end