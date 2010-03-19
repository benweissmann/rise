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
	# allow outside access to the position and size properties
	attr_accessor :x, :y

	# constructor.
	# up_key: key that moves this paddle up
	# down_key: key that moves this paddle down
	# start_x: starting x coord of the upper-left corner
	# start_y: starting y coord of the upper-left corner
	# width: width of the the paddle
	# height: height of the paddle
	def initialize up_key, down_key, start_x, start_y
		super('paddle.png')

		# attach the move_up and move_down methods to their keys
		make_magic_hooks_for(self, {
			up_key => :move_up,
			down_key => :move_down,
			KeyReleased => :key_released
		})

		# record the up and down keys for use in #stop
		@up_key = up_key
		@down_key = down_key

		# starting position
		@x = start_x
		@y = start_y
	end

	def move_up
		@y_velocity = -4
	end

	def move_down
		@y_velocity = 4
	end

	def key_released key_event
		# only stop if the released key was a movement key
		if [@up_key, @down_key].include? key_event.key
			@y_velocity = 0
		end
	end
end