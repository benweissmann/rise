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
	IMG_SRC = 'ball.png'
	IMG_WIDTH = 10
	IMG_HEIGHT = 10

	def initialize start_x, start_y, start_x_vel, start_y_vel, left_paddle, right_paddle
		super()

		@x = start_x
		@y = start_y
		@xv = start_x_vel
		@yv = start_y_vel

		@left_paddle = left_paddle
		@right_paddle = right_paddle

		@image = Surface[IMG_SRC]
		@rect = @image.make_rect
		@rect.topleft = @x, @y
	end

	def update
		if @y <= 0
			@y = 0
			@yv = -@yv
		elsif @y >= EasyRubygame.window_height
			@y = EasyRubygame.window_height
			@yv = -@yv
		end

		if self.collide_sprite?(@left_paddle) or self.collide_sprite?(@right_paddle)
			@xv = -@xv
		end

		if @x + IMG_WIDTH >= EasyRubygame.window_width
			puts "left wins!"
			@x = EasyRubygame.window_width
			exit
		elsif @x <= 0
			puts "right wins!"
			@x = 0
			exit
		end
		@x += @xv
		@y += @yv
		@rect.topleft = @x, @y
	end
end
