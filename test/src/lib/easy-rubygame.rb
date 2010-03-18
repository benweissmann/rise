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

require 'yaml'
require 'lib/scenes'
require 'lib/sprites'
module EasyRubygame
  def EasyRubygame.init
    Rubygame.init
    properties = YAML.load_file(BASE_DIR + 'properties.yml')
    EasyRubygame.window_height = properties['height']
    EasyRubygame.window_width = properties['width']

    @screen = Screen.new [properties['width'], properties['height']]
    @screen.title = properties['title']
    @screen.show_cursor = true;
    EasyRubygame.screen = screen

    @clock = Clock.new
	  @clock.target_framerate = 30
  end

  def EasyRubygame.run
    @queue = Rubygame::EventQueue.new
    @queue.enable_new_style_events

    loop do
      @clock.tick
      EasyRubygame.active_scene.draw @queue
      EasyRubygame.screen.update
    end
  end

  class << self
    attr_accessor :screen, :clock, :active_scene
    attr_accessor :window_height, :window_width
  end
end


