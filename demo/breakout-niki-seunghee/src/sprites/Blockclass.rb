#creating the block class which will get destroyed should make you "win"
class Block < Sprite

#initialized the blocks with a different image, location and number
#of times it needs to be hit to break
  def initialize(x, y, image, lives)
    super(image)
    @x = x
    @y = y
    @lives = lives
  end

# what happens to the bricks when it gets hit

  
end