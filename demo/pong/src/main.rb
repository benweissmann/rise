# Copyright (C) 2010 Ben Weissmann <benweissmann@gmail.com>
#
# This file is part of RISE.
#
# RISE is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# RISE is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with RISE, in a file called COPYING.LESSER.
# in addition, your should have received a copy of the GNU General
# Public License, in a file called COPYING. If you did not
# receive a copy of either of these documents, see
# <http://www.gnu.org/licenses/>.

ball = Ball.new(250, 250, 2, 2)
paddle_one = AutoPaddle.new(ball, 0)
paddle_two = AutoPaddle.new(ball, 490)


main_scene = Scene.new
main_scene.sprites.push paddle_one, paddle_two, ball
RISE.active_scene = main_scene
