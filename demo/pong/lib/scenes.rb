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
  # Represents a group of scenes.
  class Scene
    attr_accessor :sprites
    
    def initialize(background = nil)
      self.background = (background || [255, 255, 255])
      @sprites = Sprites::Group.new
    end

    def background= bg
      @background = Surface.new(EasyRubygame.screen.size)

      case bg
      when Array # color array
        @background.fill bg
      when Symbol
        @background.fill Color::CSS[bg]
      when String
        image = Surface[bg]
        0.step EasyRubygame.window_width, image.w do |x|
          0.step EasyRubygame.window_height, image.h do |y|
            image.blit @background, [x, y]
          end
        end
      end  
    end
    
    def draw event_queue
      @sprites.update
    
      @background.blit EasyRubygame.screen, [0,0], nil
      @sprites.each do |sprite|
     	  sprite.draw(EasyRubygame.screen) if sprite.visible?
      end
    end

    def propagate_event event
      @sprites.call(:handle, event)
    end
  end
end
