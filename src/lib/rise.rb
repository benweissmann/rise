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

require 'yaml'
require 'lib/scenes'
require 'lib/sprites'
require 'lib/text'
require 'lib/sounds'
require 'lib/timer'

# Global RISE module. Escapsuates core functions and utilities.
module RISE
  class << self
    # The Screen object that represents the game's window
    attr_accessor :screen

    # The scene that's currently being drawn to the screen. Change
    # this to change the scene.
    attr_accessor :active_scene

    # The height of the game window
    attr_accessor :window_height

    # The width of the game window
    attr_accessor :window_width

    # A hash of key (Symbol) => pressed state (Boolean).
    # So RISE.keys[:x] is true while the x key is down,
    # an false while it is up.
    attr_accessor :keys

    # General storage for objects that need to be accessible
    # everywhere.
    attr_reader :storage
    
    # Initializes RISE. Called automatically by runner.rb.
    def init #:nodoc:
      Rubygame.init
      TTF.setup
      
      properties = YAML.load_file(BASE_DIR + 'properties.yml')
      RISE.window_height = properties['height']
      RISE.window_width = properties['width']

      @screen = Screen.new [properties['width'], properties['height']]
      @screen.title = properties['title']
      @screen.show_cursor = true;
      RISE.screen = screen
      
      @storage = {}

      @clock = Clock.new
	    fps = properties['fps']
	    if fps == nil
	      fps = 30
	    end
	    @clock.target_framerate = fps
	    
	    
	    @start_time = Time.new.to_i
	    
	    @sounds = {}
    end

    # Runs the main RISE loop. Called automatically by runner.rb.
    def run #:nodoc:
      @queue = Rubygame::EventQueue.new
      @queue.enable_new_style_events
      RISE.keys = Hash.new false

      loop do
        @clock.tick
        Timer.pass_frame
        @queue.each do |event|
          case event
          when QuitEvent
            return
          when KeyPressed
            if event.key == :escape
              return
            else
              RISE.keys[event.key] = true
            end
          when KeyReleased
            RISE.keys[event.key] = false
          end

          if RISE.active_scene.nil?
            raise "RISE.active_scene has not been set in main.rb."
          end

          RISE.active_scene.propagate_event event
        end
        RISE.active_scene.draw @queue
        RISE.screen.update
      end
    end
    
    # Get the time since the game has started, in seconds.
    def time_elapsed
      return Time.new.to_i - @start_time
    end
    
    # Returns an [r, g, b] array from one of the following:
    # - One of Rubygame's ColorBase objects
    # - A hash with :h, :s, :v keys
    # - A hash with :h, :s, :l keys
    # - A hash with :r, :g, :b keys
    # - An array (or other Enumerable) in [r, g, b] format
    # - A symbol corresponding to a color. All standard CSS
    #   color names may be used.
    def to_color obj
      color = Color[:black]
      # color object
      if obj.kind_of? Color::ColorBase
        color = obj
      # hsv hash
      elsif obj.kind_of? Hash and obj[:h] and obj[:s] and obj[:v]
        color = Color::ColorHSV.new [obj[:h], obj[:s], obj[:v]]
      # hsl hash
      elsif obj.kind_of? Hash and obj[:h] and obj[:s] and obj[:l]
        color = Color::ColorHSL.new [obj[:h], obj[:s], obj[:l]]
      # rgb hash 
      elsif obj.kind_of?(Hash) and obj[:r] and obj[:g] and obj[:b]
        color = Color::ColorRGB.new [obj[:r], obj[:g], obj[:b]]
      # rgb array / enumerable
      elsif obj.kind_of? Enumerable and obj.length == 3
        return obj.to_a
      # can we make it a string? if so, look it up in the global color
      # palette
      elsif obj.respond_to? :to_s
        color = Color[obj.to_s.intern]
      end

      return color.to_rgba_ary[0..2].collect{|n| n*255}
    end
    
    def active_scene=(new_scene)
      
      if nil == new_scene
        raise("Active scene was set to nil, must be an initialized Scene")
      end
      
      @active_scene = new_scene
    end

    # Reports a method as deprecated. Should be called ONLY from
    # inside a deprecated method, else line number reporting
    # won't work.
    #
    # +old+ :: Name of deprecated method
    # +new+ :: Name of method to use instead
    def deprecate old, new #:nodoc:
      puts "WARNING: #{old} is deprecated; use #{new} instead."
      puts "From #{caller[1]}" 
    end
  end
end


