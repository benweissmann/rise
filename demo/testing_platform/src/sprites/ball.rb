# Copyright (C) 2010 Ben Weissmann <benweissmann@gmail.com>
#
# This file is part of EasyRubygame.
#
# EasyRubygame is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# EasyRubygame is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with EasyRubygame, in a file called COPYING.LESSER.
# in addition, your should have received a copy of the GNU General
# Public License, in a file called COPYING. If you did not
# receive a copy of either of these documents, see
# <http://www.gnu.org/licenses/>.

class Ball < Sprite
	def initialize start_x, start_y, start_x_vel, start_y_vel
		super('ball.gif')
		@x = start_x
		@y = start_y
		@x_velocity = start_x_vel
		@y_velocity = start_y_vel
		
		self.add_animation(:explode, ["explode1.gif", "explode2.gif", "explode3.gif"], [20, 20, 20])
		self.add_animation(:unexplode, ["explode3.gif", "explode2.gif", "explode1.gif", :default], [200, 20, 20])
		
		#self.play_animation(:explode)
		#self.play_animation(:unexplode)
		
		self.y_acceleration = 0
		
	end

  def collide_with_Floor(floor)
    self.y_velocity = 0
    puts "hello"
    #raise "hi"
   # self.y = floor.y
  end

  def key_pressed_left
    @x_velocity = -3
  end
  
  def key_released_left
    @x_velocity = 0
  end
  
  def key_pressed_right
    @x_velocity = 3
  end
  
  def key_released_right
    @x_velocity = 0
  end

  def touch_top
    @y_velocity = -@y_velocity
  end

  def touch_bottom
    @y_velocity = -@y_velocity
  end

  def touch_left
    @x_velocity = -@x_velocity
  end

  def touch_right
    @x_velocity = -@x_velocity
  end
  

end
