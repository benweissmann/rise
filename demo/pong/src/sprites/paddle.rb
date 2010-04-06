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

# paddle class -- represents one of the controllable paddles
class Paddle < Sprite
	# constructor.
	# start_x: starting x coord of the upper-left corner
	# start_y: starting y coord of the upper-left corner
	def initialize start_x, start_y
		super('paddle.gif')

		# starting position
		@x = start_x
		@y = start_y
	end

	def key_pressed_up
		@y_velocity = -4
	end

	def key_pressed_down
		@y_velocity = 4
	end

  def key_released_up
    @y_velocity = 0
  end

  def key_released_down
    @y_velocity = 0
  end
end