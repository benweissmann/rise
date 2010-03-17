# To change this template, choose Tools | Templates
# and open the template in the editor.
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


