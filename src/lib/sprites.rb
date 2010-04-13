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
  # EasyRubygame's base sprite class. All sprites should inherit from
  # Sprite.
  class Sprite
    # include the Rubygame Sprite module
    include Sprites::Sprite
    include EventHandler::HasEventHandler

    attr_accessor :x, :y, :x_velocity, :y_velocity, :x_acceleration,
                  :y_acceleration, :visible
                  
    attr_reader :sprites, :prev_x, :prev_y, :images

	# Sets up the sprite. Sets positions, velocities, and
	# accelerations to 0. The specified img_src is loaded and used
	# as the sprite's default image. 
    def initialize(img_src)
      super()
      @x = @y = @prev_x = @prev_y = @x_velocity = @y_velocity = @x_acceleration = @y_acceleration = 0
      @visible = true
      @images = Hash.new
      self.add_image :default, img_src
      self.change_image :default
      
      @code_to_execute = []

      @@update_procs[self.class] ||= []
      @@hooks[self.class] ||= Hash.new
      self.make_magic_hooks @@hooks[self.class]
    end

    # Main update method
    def update # :nodoc:
      self.update_wait()
      return unless @visible
      @@update_procs[self.class].each {|p| instance_eval &p}
      
      @prev_x, @prev_y = @x, @y

      @x_velocity += @x_acceleration
      @y_velocity += @y_acceleration

      @x += @x_velocity
      @y += @y_velocity

      begin
        if @x <= 0
          self.touch_left
        elsif @x + @rect.width >= EasyRubygame.window_width
          self.touch_right
        end

        if @y <= 0
          self.touch_top
        elsif @y + @rect.height >= EasyRubygame.window_height
          self.touch_bottom
        end
      rescue NoMethodError
        # ignore NoMethodErrors -- the subclass might not have
        # defined touch_* methods
      end

      @rect.topleft = @x, @y
      pass_frame if @visible
    end

    # Magic Method: Called every frame.
    def pass_frame
    end

    # Returns the integer distance between the left side of this
    # sprite and the left edge of the window.
    def distance_from_left
      return @x
    end

    # Returns the integer distance between the right side of this
    # sprite and the right edge of the window.
    def distance_from_right
      return EasyRubygame.window_width - @x - @rect.width
    end

    # Returns the integer distance between the top side of this
    # sprite and the top edge of the window.
    def distance_from_top
      return @y
    end

    # Returns the integer distance between the bottom side of this
    # sprite and the bottom edge of the window.
    def distance_from_bottom
      return EasyRubygame.window_width - @x - @rect.width
    end

    # Returns the smaller of:
	  # - The integer distance between the top side of this sprite
    # and the top edge of the window, or
    # - The integer distance between the bottom side of this sprite
    # and the bottom edge of the window.
    def distance_from_top_bottom
      return [self.distance_from_top, self.distance_from_bottom].min
    end

    # Returns the smaller of:
	  # - The integer distance between the left side of this sprite
    # and the left edge of the window, or
    # - The integer distance between the right side of this sprite
    # and the right edge of the window.
    def distance_from_left_right
      return [self.distance_from_left, self.distance_from_right].min
    end

    # Returns true if any part of this sprite is onscreen, false
    # otherwise.
    def onscreen?
      return !self.offscreen?
    end

    # Returns true if no part of this sprite is onscreen, false
    # otherwise.
    def offscreen?
      return (@x > EasyRubygame.window_width) ||
             (@y > EasyRubygame.window_height) ||
             (@x < -@rect.width) ||
             (@y < -@rect.height)
    end

    def add_sprite name, file # :nodoc:
      puts "WARNING: Sprite#add_sprite is deprecated; use add_image instead"
      add_image name, file
    end

    def change_sprite name # :nodoc:
      puts "WARNING: Sprite#change_sprite is deprecated; use change_image instead"
      change_image name
    end
    
    # Adds an image to the list of images this sprite uses.
    def add_image name, file
	  @images[name] = Surface[file]
    end

    def change_image name
      self.surface = @images[name]
    end

    def hide
      @visible = false
    end

    def show
      @visible = true
    end

    def visible?
      @visible
    end
    
    # Will have the sprite wait the specified number of
    # frames, and then execute the given block. For example, 
    # <tt> self.wait(10) {@y_velocity = 0} </tt>
    # will set the y_velocity to 0 after 10 frames.
    def wait(frames, &code)
      @code_to_execute.push([frames, code])
    end
    
    private

    #Called every frame to make Sprite#wait work
    def update_wait() #:nodoc:
      @code_to_execute.collect! do |time_and_code|
        time, code = time_and_code
        if time==0
          self.instance_eval &code
          nil
        else
          time -= 1
          [time, code]
        end
      end
      @code_to_execute.compact!
    end

    def surface= surface
      @image = surface
      @rect = @image.make_rect
      @rect.topleft = @x, @y
    end

    public

    def Sprite.init
      @@hooks = Hash.new
      @@update_procs = Hash.new
    end
    
    def Sprite.method_added name

      @@hooks[self] ||= Hash.new
      @@update_procs[self] ||= Array.new

      parts = name.to_s.split '_'

      if parts.length > 1
        first_part = "#{parts[0]} #{parts[1]}"
      else
        first_part = parts[0]
      end

      case first_part
      when "key pressed"
        @@hooks[self][parts[2].intern] = name
      when "key released"
        @@hooks[self][KeyReleaseTrigger.new(parts[2].intern)] = name
      when "key down"
        key = parts[2].intern
        @@update_procs[self].push proc {
          if EasyRubygame.keys[key]
            self.send name
          end
        }
      when "key up"
        key = parts[2].intern
        @@update_procs[self].push proc {
          unless EasyRubygame.keys[key]
            self.send name
          end
        }
      when "collide"
        @@update_procs[self].push proc {
          EasyRubygame.active_scene.sprites.each do |sprite|
            if self.collide_sprite? sprite
              self.send name, sprite
            end
          end
        }
      when "collide with"
        @@update_procs[self].push proc {
          klass = Object.const_get parts[2..-1].join('_').intern
          EasyRubygame.active_scene.sprites.each do |sprite|
            if sprite.kind_of? klass and self.collide_sprite? sprite and sprite.visible and self.visible
              self.send name, sprite
            end
          end
        }
      end
    end
  end
end

EasyRubygame::Sprite.init
