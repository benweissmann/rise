class Bullet < Sprite
  
  #basic bullet class that deals with getting rid of it once it's off screen
  def update
    super()
    if(self.offscreen?)
      self.hide
    end
  end
  
end