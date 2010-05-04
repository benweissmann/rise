#created player controlled paddle
class Paddle < Sprite

# initialize with location as parm. default img
   def initialize(startx, starty)
      super('paddle.gif')
      @x = startx
      @y = starty
      @x_velocity = 0
   end

   #player controls for movement
   def key_pressed_left
     @x_velocity = -10
   end

   def key_released_left
     @x_velocity = 0
   end

   def key_pressed_right
     @x_velocity = 10
   end

   def key_released_right
     @x_velocity = 0
   end

   
end
