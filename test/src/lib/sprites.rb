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

module EasyRubygame
  # EasyRubygame's base sprite class
  class Sprite
    # include the Rubygame Sprite module
    include Sprites::Sprite
    include EventHandler::HasEventHandler

    def initialize(img_src)
      super()
      @x = 0
      @y = 0
      @x_velocity = 0
      @y_velocity = 0
      self.image = img_src
    end
    
    def update
      @x += @x_velocity
      @y += @y_velocity

      begin
        if @x <= 0
          @x = 0
          self.touch_left
        elsif @x + @rect.width >= EasyRubygame.window_width
          @x = EasyRubygame.window_width - @rect.width
          self.touch_right
        end

        if @y <= 0
          @y = 0
          self.touch_top
        elsif @y + @rect.height >= EasyRubygame.window_height
          @y = EasyRubygame.window_height - @rect.height
          self.touch_bottom
        end
      rescue NoMethodError
        # ignore NoMethodErrors -- the subclass might not have defined
        # touch_* methods
      end

      @rect.topleft = @x, @y
    end
    
    def image= img_src
      @image = Surface[img_src]
      @rect = @image.make_rect
      @rect.topleft = @x, @y
    end
  end
end