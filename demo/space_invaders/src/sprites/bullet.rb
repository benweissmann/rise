class Bullet < Sprite
  
  def update
    super()
    if(self.offscreen?)
      self.hide
    end
  end
  
end