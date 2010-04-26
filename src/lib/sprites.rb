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

    # The current x position of the top-left corner of this sprite.
    attr_accessor :x

    # The current y position of the top-left corner of this sprite.
    attr_accessor :y

    # The x position of this sprite will be adjusted by this amount
    # each frame. Can be negative.
    attr_accessor :x_velocity

    # The y position of this sprite will be adjusted by this amount
    # each frame. Can be negative.
    attr_accessor :y_velocity

    # The x velocity of this sprite will be adjusted by this amount
    # each frame. Can be negative.
    attr_accessor :x_acceleration

    # The y velocity of this sprite will be adjusted by this amount
    # each frame. Can be negative.
    attr_accessor :y_acceleration

    # Whether this sprite is visible. Can also be changed and
    # detected with hide, show, and visible?
    attr_accessor :visible
                  
    attr_reader :sprites, :prev_x, :prev_y, :images, :name, :time

	  # Sets up the sprite. Sets positions, velocities, and
	  # accelerations to 0. The specified img_src is loaded and used
	  # as the sprite's default image. 
    def initialize(img_src)
      super()
      @x = @y = @prev_x = @prev_y = @x_velocity = @y_velocity = 
           @x_acceleration = @y_acceleration = 0
      @visible = true
      @images = Hash.new
      
      @animations = Hash.new
      @animation_queue = Queue.new
      @currently_animating = false
      
      if img_src
        self.add_image :default, img_src
        self.change_image :default
      end
      
      @code_to_execute = []

      @@update_procs[self.class] ||= []
      @@hooks[self.class] ||= Hash.new
      self.make_magic_hooks @@hooks[self.class]
      
      @start_time = Time.new.to_i
      
      @can_move = true
    end

    # Main update method
    def update # :nodoc:
      self.update_wait()
      return unless @visible
      @@update_procs[self.class].each {|p| instance_eval &p}
      
      #will prevent it from moving if crippled
      if @can_move
        @prev_x, @prev_y = @x, @x
        
        @x += @x_velocity
        @y += @y_velocity
        
        @x_velocity += @x_acceleration
        @y_velocity += @y_acceleration
      end

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

      if @rect 
        @rect.topleft = @x, @y
      end
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
      puts "WARNING: Sprite#add_sprite is deprecated; 
            use add_image instead"
      add_image name, file
    end
    
    def change_sprite name # :nodoc:
      puts "WARNING: Sprite#change_sprite is deprecated; 
            use change_image instead"
      change_image name
    end
    
    # Adds an image to the list of images this sprite uses. "name" is
    # a symbol that will be used in Sprite#change_image. "file" is
    # the name of a file in resources/images.
    def add_image name, file
	    @images[name] = Surface[file]
    end
    
    # adds a hash of names to file locations to the images array.
    # like this: self.add_images {:a => "a.gif", :b => "b.gif"}
    def add_images names_and_files
      names_and_files.each do |name, file_loc|
        self.add_image(name, file_loc)
      end
    end

    # Changes the image this sprite is currently using to the image
    # associated with the given name (by Sprite#add_image)
    def change_image name
      @name = name
      self.surface = @images[name]
    end

    # Makes this sprite invisible. While a sprite is invisible, none
    # of its magic methods (including pass_frame) are called, and it
    # does not activate collisions.
    def hide
      @visible = false
    end

    # Makes an invisible sprite visible again. See Sprite#hide.
    def show
      @visible = true
    end

    # Returns a boolean representing the visibility of this sprite.
    def visible?
      @visible
    end

    def time
      return Time.new.to_i - @start_time
    end
    
    def reset_timer
      @start_time = Time.new.to_i
    end
    
    # Will have the sprite wait the specified number of
    # frames, and then execute the given block. For example, 
    # <tt> self.wait(10) {@y_velocity = 0} </tt>
    # will set the y_velocity to 0 after 10 frames.
    def wait(frames, &code)
      @code_to_execute.push([frames, code])
    end
    
    # Called every frame to make Sprite#wait work
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
    
    #prevents the sprite from moving
    def freeze
      @can_move = false
    end
    
    #allows it to move again
    def unfreeze
      @can_move = true
    end
    
    # load an animation into the image.
    # images in an array of images
    # times can be a single number if everything is evenly spaced,
    # or an array of how long each image will be up
    # currently revert_when_done will revert to whatever image you had 
    # loaded when adding the animation
    # potentially not the desired behavior, may be changed to current
    # when playing the animation
    def add_animation(key, images, times, revert_when_done=false)
      if revert_when_done
        images.push @name
      end
      @animations[key] = [images, times]
    end
    
    # plays the animation immeditly
    def play_animation(key)
      
      if @currently_animating
        @animation_queue.push(key)
      else
        @currently_animating = true
        images_and_times = @animations[key]
        if images_and_times != nil
          play_frame(images_and_times[0], images_and_times[1])
        else
          raise "Error: No animation #{key} found."
        end
      end
    end  
    
    private
    
    #helper method to play all of the frames in the animation
    def play_frame(images, times)
      img = images[0]
      
      case img
      when String
        self.add_image(images[0].to_sym, images[0])
        self.change_image(images[0].to_sym)
      else
        self.change_image(img)
      end
      
      images.shift
      case times
      when Numeric
        self.wait(times) do
          play_frame(images, times)
        end
      else
        time = times.shift
        if time == nil
          time = 1
        end
        
        if images.empty?
          @currently_animating = false
          if @animation_queue.empty?
            return
          else
            self.wait(time) do
              play_animation(@animation_queue.pop)
            end
          end
        else
          self.wait(time) do
            play_frame(images, times)
          end
        end
      end
    end
        

    # Changes the current Surface (used as the sprite's image) in a
    # way that makes Rubygame happy.
    def surface= surface
      @image = surface
      if surface == nil
        raise "ERROR. Could not find the image \"#{@name},\" exiting immediately. Check your spelling."
      end
      @rect = @image.make_rect
      @rect.topleft = @x, @y
    end

    public

    class << self
      def init #:nodoc:
        @@hooks = Hash.new
        @@update_procs = Hash.new
      end
      
      def method_added name #:nodoc:
        @@hooks[self] ||= Hash.new
        @@update_procs[self] ||= Array.new

        parts = name.to_s.split '_'

        if parts.length > 1
          first_part = "#{parts[0]} #{parts[1]}"
        else
          first_part = parts[0]
        end

        case first_part

        ##
        # :method: key_pressed_*
        # Magic method: called when a specific key is pressed. For
        # example, "key_pressed_k" is called when the "k" key is
        # pressed.
        when "key pressed"
          @@hooks[self][parts[2].intern] = name
          
        ##
        # :method: key_released_*
        # Magic method: called when a specific key is released. For
        # example, "key_released_k" is called when the "k" key is
        # released.
        when "key released"
          @@hooks[self][KeyReleaseTrigger.new(parts[2].intern)] = name


        ##
        # :method: key_down_*
        # Magic method: called when a specific key is down. For
        # example, "key_down_k" is called when the "k" key is
        # down.
        when "key down"
          key = parts[2].intern
          @@update_procs[self].push proc {
            if EasyRubygame.keys[key]
              self.send name
            end
          }

        ##
        # :method: key_up_*
        # Magic method: called when a specific key is up. For
        # example, "key_up_k" is called when the "k" key is
        # up.        
        when "key up"
          key = parts[2].intern
          @@update_procs[self].push proc {
            unless EasyRubygame.keys[key]
              self.send name
            end
          }

        ##
        # :method: collide
        # Magic method: called when this sprite touches another
        # sprite. The method is passed the sprite it collided
        # with.
        when "collide"
          @@update_procs[self].push proc {
            EasyRubygame.active_scene.sprites.each do |sprite|
              if self.collide_sprite? sprite
                self.send name, sprite
              end
            end
          }

        ##
        # :method: collide_with_*
        # Magic method: called when this sprite touches a another
        # sprite of a specific class. For example,
        # "collide_with_Ball" is called when this sprite collides
        # with an instance of Ball. The method is passed the sprite
        # it collided with.
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
end

EasyRubygame::Sprite.init
