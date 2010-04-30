module EasyRubygame
  # EasyRubygame's base sprite class. All sprites should inherit from
  # Sprite.
  #
  # Classes that inherit from sprite can define "magic methods". These
  # methods are called automatically based on their name.
  #
  # +pass_frame+::     Called every frame
  # +key_pressed_*+::  Called when a specific key is pressed. For
  #                    example, "key_pressed_k" is called when the
  #                    "k" key is pressed.
  # +key_released_*+:: Called when a specific key is released. For
  #                    example, "key_released_k" is called when the
  #                    "k" key is released.
  # +key_down_*+::     Called when a specific key is down. For
  #                    example, "key_down_k" is called when the "k"
  #                    key is down.
  # +key_up_*+::       Called when a specific key is up. For example,
  #                    "key_up_k" is called when the "k" key is up.        
  # +collide+::        Called when this sprite touches another
  #                    sprite. The method is passed the sprite it
  #                    collided with.
  # +collide_with_*+:: Called when this sprite touches another sprite
  #                    of a specific class. For example,
  #                    "collide_with_Ball" is called when this sprite
  #                    collides with an instance of Ball. The method
  #                    is passed the sprite it collided with.
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

    # Allows the code to update the position / velocity when hidden.
    attr_accessor :move_when_hidden

    # Whether this sprite is visible. Can also be changed and
    # detected with hide, show, and visible?
    attr_accessor :visible

    # The x coordinate of this sprite in the previous frame              
    attr_reader :prev_x

    # The y coordinate of this sprite in the previous frame   
    attr_reader :prev_y

    # Hash of image names to their corresponding Surface
    attr_reader :images

    # Name of the current image
    attr_reader :current_image

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
      @animation_queue = []
      @currently_animating = false
      
      if img_src
        self.add_image :default, img_src
        self.change_image :default
      end
      
      @code_to_execute = []

      @@update_procs[self.class] ||= Hash.new
      @@hooks[self.class] ||= Hash.new
      self.make_magic_hooks self.class.hooks
      
      @start_time = Time.new.to_i
      
      @can_move = true
      
      @move_when_hidden = false
      
    end
    
    # Main update method
    def update # :nodoc:
      update_wait

      #will prevent it from moving if crippled
      if @can_move and !@visible and @move_when_hidden
        update_movement
      end
      
      return unless @visible
      self.class.update_procs.each {|name, proc| instance_eval &proc}
      
      if @can_move
        update_movement
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

      unless @rect.nil?
        self.update_rect
      end
      pass_frame if @visible
    end
    
    def update_movement
      @prev_x, @prev_y = @x, @x
      
      @x += @x_velocity
      @y += @y_velocity
      
      @x_velocity += @x_acceleration
      @y_velocity += @y_acceleration
    end

    # Updates @rect to reflect current @x and @y.
    def update_rect #:nodoc:
      @rect.topleft = @x, @y
    end

    def pass_frame #:nodoc:
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
      return EasyRubygame.window_height - @y - @rect.height
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
    
    # Returns the width, in pixles, of the current image
    def image_width
      return self.rect.width
    end
    
    # Return the height, in pixles, of the current image
    def image_height
      return self.rect.height
    end
    
    # depricated, remove in a few versions
    def name
      puts '      ______________________________________
      / WARNING: name is depricated,         \
      \ use image_name instead               /
       --------------------------------------
              \   ^__^
               \  (oo)\_______
                  (__)\       )\/\
                      ||----w |
                      ||     ||
      '
      return self.current_image
    end
    
    # Adds an image to the list of images this sprite uses. "name" is
    # a symbol that will be used in Sprite#change_image. "file" is
    # the name of a file in resources/images.
    def add_image name, file
	    surface = Surface[file]
	    if surface
	      @images[name] = surface
	    else
        raise "ERROR. Could not find the image \"#{file}.\" Exiting immediately. Make sure that \"#{file}\" is in resources/sprites."
      end
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
      @current_image = name
      surface = @images[name]
      if surface
        self.surface = @images[name]
      else
        raise "ERROR. No image added with the name \"#{name}\""
      end
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

    # Returns the time (in seconds) since this sprite was created.
    def time_elapsed
      return Time.new.to_i - @start_time
    end

    # Resets the timer used by Sprite#time_elapsed
    def reset_timer
      @start_time = Time.new.to_i
    end
    
    # Will have the sprite wait the specified number of
    # frames, and then execute the given block. For example, 
    # <tt> self.wait(10) {@y_velocity = 0} </tt>
    # will set the y_velocity to 0 after 10 frames.
    def wait frames, &code
      @code_to_execute.push [frames, code]
    end

    # removes all current wait statements.
    def clear_waits
      @code_to_execute = []
    end
    
    # depricated, see clear_waits
    def remove_waits
      puts '     ______________________________________
      / WARNING: remove_waits is depricated, \
      \ use clear_waits instead              /
       --------------------------------------
              \   ^__^
               \  (oo)\_______
                  (__)\       )\/\
                      ||----w |
                      ||     ||
      '
      
      self.clear_waits
    end

    private
    
    # Called every frame to make Sprite#wait work
    # Called every frame to make Sprite#wait work
    def update_wait #:nodoc:
      @code_to_execute.collect! do |time_and_code|
        time, code = time_and_code
        if time == 0
          begin
            self.instance_eval &code
          rescue ArgumentError
            raise "No block was supplied to the wait."
          end
          nil
        else
          time -= 1
          [time, code]
        end
      end
      @code_to_execute.compact!
    end

    public
    
    # Stops this sprite from moving due to its velocity or
    # acceleration. It can stil be move by changing @x and @y.
    # See Sprite#go
    def stop
      @can_move = false
    end
    
    # Allows this sprite to move after it has been stopped by
    # Sprite#stop
    def go 
      @can_move = true
    end
    
    # Adds an animation to this sprite.
    #
    # +name+:: The name that will refer to this animation when it is
    #          played by Sprite#play_animation.
    # +images+:: The images that make up this animation, in the order
    #            they should be played.
    # +times+:: Either a single integer that represents the number
    #           of frames each image in the images parameter should
    #           be played, or an array of integers that correspond
    #           to the time each image should be played, e.g. the
    #           first item in +times+ is the number of frames the
    #           first item in +images+ is shown, and so on for the
    #           second item, third item, etc.
    # +revert_when_done+:: Optional. If this is set to true, the
    #                      sprite will revert to the image it was
    #                      using when the animation was added. This
    #                      behavior may change in the future.
    def add_animation(name, images, times, revert_when_done=false)
      if revert_when_done
        images.push @name
      end
      @animations[name] = [images, times]
    end
    
    # Queues the animation. If no animation is currently playing,
    # the animation referenced by +name+ will be played immediately.
    # If an animation is currently playing, the animation will
    # be queued and played when current animations complete.
    def play_animation(name)
      
      if @currently_animating
        @animation_queue.push(name)
      else
        @currently_animating = true
        # Marsh.load(Marshal.dump(foo)) creates a deep clone of foo.
        # needed to fix bug when running animation multiple times
        images_and_times = Marshal.load(Marshal.dump(@animations[name]))
        if images_and_times != nil
          play_frame(images_and_times[0], images_and_times[1])
        else
          raise IndexError, "No animation #{name} found."
        end
      end
    end  
    
    # stops the current animation, changes the image to the optional parmeter
    # and clears the quenue of animations
    def stop_all_animations return_to=nil
      @currently_playing = false
      @animation_queue = []
      if return_to 
        self.change_image return_to
      end
    end
    
    private
    
    #helper method to play all of the frames in the animation
    def play_frame(images, times)
      img = images[0]
      case img
      when String
        self.add_image(img.to_sym, img)
        self.change_image(img.to_sym)
      else
        self.change_image(img)
      end
      
      images.shift
      case times
      when Numeric
        self.wait(times) do
          if @currently_playing
            play_frame(images, times)
          end
        end
      when Array
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
        @@update_procs[self] ||= Hash.new

        parts = name.to_s.split '_'

        if parts.length > 1
          first_part = "#{parts[0]} #{parts[1]}"
        else
          first_part = parts[0]
        end

        case first_part

        # key_pressed_*
        when "key pressed"
          if parts[2]
            @@hooks[self][parts[2].intern] = name
          else
            raise "Missing the key in the name of some key_pressed method (ie you have key_pressed, not key_pressed_left)."
          end
          
        # key_released_*
        when "key released"
          if parts[2]
            @@hooks[self][KeyReleaseTrigger.new(parts[2].intern)] = name
          else
            raise "Missing the key in the name of some key_released method (ie you have key_pressed, not key_pressed_left)."
          end

        # key_down_*
        when "key down"
          if parts[2]
             @@update_procs[self][parts[2].intern] = proc {
                if EasyRubygame.keys[key]
                  self.send name
                end
              }
          else
            @@update_procs[self][name] = proc {
                if EasyRubygame.keys
                  keys_down = EasyRubygame.keys.reject {|key, value| !value}.keys
                  if keys_down.length > 0
                    self.send "keys_down", keys_down
                  end
                end
              }
          end
         

        # key_up_*      
        when "key up"
          if parts[2]
            key = parts[2].intern
          else
            raise "Missing the key in the name of some key_up method (ie you have key_pressed, not key_pressed_left)."
          end
          @@update_procs[self][name] = proc {
            unless EasyRubygame.keys[key]
              self.send name
            end
          }

        # collide
        when "collide"
          @@update_procs[self][name] = proc {
            EasyRubygame.active_scene.sprites.each do |sprite|
              if self.collide_sprite? sprite and self != sprite
                self.send name, sprite
              end
            end
          }
          
        # collide_with_*
        when "collide with" 
          @@update_procs[self][name] = proc {
            klass = Object.const_get parts[2..-1].join('_').intern
            EasyRubygame.active_scene.sprites.each do |sprite|
              sprite.update_rect
              if sprite.kind_of? klass and self.collide_sprite? sprite and sprite.visible and self.visible and self != sprite
                self.send name, sprite
              end
            end
          }
        end
      end

      def update_procs #:nodoc:
        procs = @@update_procs[self] 
        procs = (superclass.update_procs || {}).merge(procs) unless superclass == Sprite
        return procs
      end

      def hooks #:nodoc:
        hooks = @@hooks[self]
        hooks = (superclass.hooks || {}).merge(hooks) unless superclass == Sprite
        return hooks
      end
    end
  end
end

EasyRubygame::Sprite.init
