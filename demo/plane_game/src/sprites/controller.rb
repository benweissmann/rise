# The invisible controller sprite is responsible for
# periodically dropping missiles.
 
class Controller < Sprite
  # @missile_rate controls how often this controller
  # drops a missile. Defaults to 60.
  attr_accessor :missile_rate
  
  def initialize
    # use blank sprite image
    super("blank.gif")

    # set default missile drop rate
    @missle_rate = 60

    # Queue up the first missile drop
    queue_missile_drop
  end

  # waits a random amount of frames (no more than @missile_rate), then drop a missile
  def queue_missile_drop
      self.wait(rand(@missle_rate)) do
        self.drop_missile
      end
  end
  
  # drops a missile
  def drop_missile
      # Select random x coordinate to drop missile from
      x_coord = rand(EasyRubygame.window_width)

      # create missile
      missile = Missile.new(x_coord)

      # Add missile to active scene
      EasyRubygame.active_scene.sprites.push(missile)

      # re-queue   
      queue_missile_drop
  end
end
    
