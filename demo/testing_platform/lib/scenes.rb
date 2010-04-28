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
  # Represents a group of sprites.
  class Scene
    # An array of sprites that belong to this scene.
    attr_accessor :sprites
    
    # +background+ is an optional parameter that controls the
    # background of this scene.
    # - If it's a string, a file with that name will be loaded from
    #   resources/images and tiled to fill the background.
    # - If it represents a color (as an [r, g, b] array, the name
    #   of a color as a symbol, or any other format supported by
    #   EasyRubygame.to_color), that color will be used as the
    #   background.
    # - If it is omitted, it defaults to a white background.
    def initialize(background = :white)
      self.background = background
      @sprites = Sprites::Group.new
    end

    # Changes the background of this scene. See Scene.new for details
    # on how to specify a background.
    def background= bg
      @background = Surface.new(EasyRubygame.screen.size)

      if bg.kind_of? String
        image = Surface[bg]
        0.step EasyRubygame.window_width, image.w do |x|
          0.step EasyRubygame.window_height, image.h do |y|
            image.blit @background, [x, y]
          end
        end
      else
        @background.fill EasyRubygame.to_color(bg)
      end
    end
    
    # Draws each of the sprites to the scene.
    def draw event_queue #:nodoc:
      @sprites.update
    
      @background.blit EasyRubygame.screen, [0,0], nil
      @sprites.each do |sprite|
     	  sprite.draw(EasyRubygame.screen) if sprite.visible?
      end
    end

    # Passes an event on to all sprites in this scene.
    def propagate_event event #:nodoc
      @sprites.call(:handle, event)
    end
  end
end
