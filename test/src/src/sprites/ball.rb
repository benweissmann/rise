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
	def initialize start_x, start_y, start_x_vel, start_y_vel, left_paddle, right_paddle
		super('ball.png')

		@x = start_x
		@y = start_y
		@x_velocity = start_x_vel
		@y_velocity = start_y_vel

		@left_paddle = left_paddle
		@right_paddle = right_paddle
	end

	def update
    super()
		if self.collide_sprite?(@left_paddle) or self.collide_sprite?(@right_paddle)
			@x_velocity = -@x_velocity
		end
	end

  def touch_top
    @y_velocity = -@y_velocity
  end

  def touch_bottom
    @y_velocity = -@y_velocity
  end

  def touch_left
    puts "Right wins!"
    exit
  end

  def touch_right
    puts "Left wins!"
    exit
  end
end
