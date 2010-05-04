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
  # +colliding_*_of_$  Called when this sprite touches the * side of
  #                    class $. For example, "colliding_left_of_Ball"
  #                    is called when the sprite collides into the 
  #                    boundry of Ball. The method passes the spirte
  #                    that it collided with (in this case, Ball)
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
      @wait_untils = []

      @@update_procs[self.class] ||= Hash.new
      @@hooks[self.class] ||= Hash.new
      self.make_magic_hooks self.class.hooks
      
      @@collide_side_methods[self.class] ||= Hash.new []
      
      @start_time = Time.new.to_i
      
      @can_move = true
      
      @move_when_hidden = false
      
      @side_collides = self.class.colliding_side_methods
      
      @collided_with_last_frame = Set.new []
    end
    
    # Main update method
    def update # :nodoc:
      update_wait
      check_and_execute_wait_untils

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
      @prev_x, @prev_y = @x, @y
      
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
    
    # will check every frame to see if pred is true. if so, sprite 
    # will execute function. For example,
    # <tt> self.add_wait_until lambda {@x > 100}, lambda {puts "hi there!"} </tt>
    # will puts "hi there!" after x gets past 100. 
    # Lambda is a method that turns code into an object that can be
    # easily passed to methods. pred should return a boolean
    def add_wait_until pred, function
      @wait_untils.push [pred, function]
    end
    
    #:nodoc:
    def check_and_execute_wait_untils
      @wait_untils.collect! do |pred_fn_pair|
        pred = pred_fn_pair[0]
        fn = pred_fn_pair[1]
        
        if pred.call
          fn.call
          nil
        else
          pred_fn_pair
        end
      end
      
      @wait_untils.compact!
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
    
    
    def x_midpoint
      return @x + self.image_width/2
    end

    def y_midpoint
      return @y + self.image_height/2
    end

    def x=(new_x)
      @prev_x = @x
      @x = new_x
    end
    
    def y=(new_y)
      @prev_y = @y
      @y = new_y
    end
    
    # the change in x from the last frame
    def delta_x
      return @x - @prev_x
    end
    
    # the change in y from the last fame
    def delta_y
      return @y - @prev_y
    end
    
    #:nodoc:
    def call_collide_sides sprite
      
      klass = sprite.class.to_s
      methods = @@collide_side_methods[self][klass.intern]
      
      # checks to see if any colliding_*_of_#{klass} methods have been defined
      if methods != nil
        d_x = self.delta_x
        d_y = self.delta_y
        
        # get the directions, as booleans, that the sprite is moving in
        moving_down = d_y > 0
        moving_right = d_x > 0
        
        # figure out which methods we'll eventually need to call
        if moving_down
          y_direction = "top"
        else
          y_direction = "bottom"
        end
        
        if moving_right
          x_direction = "right"
        else
          x_direction = "left"
        end
        
        #dealing with some edge cases - ie cases where it hasn't moved
        #or the slope is undefined or 0
        if d_x == 0 and d_y == 0
          return
        elsif d_x == 0
          if moving_down
            self.send_direction_collision y_direction, sprite, methods
          else
            self.send_direction_collision y_direction, sprite, methods
          end
          return
        elsif d_y == 0
          if moving_right
            self.send_direction_collision x_direction, sprite, methods
          else
            self.send_direction_collision x_direction, sprite, methods
          end
          return
        end
      
        slope = d_y.to_f/d_x
        #assertion: slope is not equal to 0 or infinity
      
        # connect the lines between the previous and current rects.
        # now, see how many of those lines intersect with the rect
        # of sprite. call the side that has the most.
        
        # these two if statements get the x/y coordinate of the interescion
        # ie the side of the sprite's rect
        if moving_down #colliding top
          y_top_bottom = sprite.y
        else
          y_top_bottom = sprite.y+sprite.image_height
        end
        
        if moving_right #colliding left
          x_left_right = sprite.x
        else
          x_left_right = sprite.x+sprite.image_width
        end
        
        top_bottom_intersects = 0
        left_right_intersects = 0
        
        original_distance = distance_between(@x, @y, @prev_x, @prev_y)
        
        # 8 points around the rectangle
        x_y_diff = [[0, 0], [0, self.image_height/2.0], [0, self.image_height], [self.image_width/2.0, 0], [self.image_width/2.0, self.image_height], [self.image_width, 0], [self.image_width, self.image_height/2.0], [self.image_width, self.image_height]]
       
       # for each point, go through, find the other coordinate of the intersection
       # then see if it was a valid collision
        x_y_diff.each do |point|
          x_val = point[0]+@x
          y_val = point[1]+@y
       
          # calculated using the point-slope form
          left_right_intercept = y_val + (x_left_right-x_val)*slope
          top_bottom_intercept = (y_top_bottom-y_val)/slope + x_val
          
          if distance_between(@prev_x+point[0], @prev_y+point[1], x_left_right, left_right_intercept) < original_distance
            left_right_intersects += 1
          end
          
          if distance_between(@prev_x+point[0], @prev_y+point[1], top_bottom_intercept, y_top_bottom) < original_distance
            top_bottom_intersects += 1
          end
          
        end
        
        
        if 0 == top_bottom_intersects and 0 == left_right_intersects
          return
        elsif top_bottom_intersects == left_right_intersects
          #send both
          self.send_direction_collision y_direction, sprite, methods
          self.send_direction_collision x_direction, sprite, methods
        elsif top_bottom_intersects > left_right_intersects
          #send top|down
          self.send_direction_collision y_direction, sprite, methods
        else
          #send left|right
          self.send_direction_collision x_direction, sprite, methods
        end
      
      else
        return
      end
    end
    
    def distance_between x_1, y_1, x_2, y_2
      return Math.sqrt((x_1-x_2)**2 + (y_1-y_2)**2)
    end 
    
    def send_direction_collision direction, sprite, possible_methods
      if possible_methods.include? direction
        send "colliding_#{direction}_of_#{sprite.class}", sprite
      end
    end

    class << self
      def init #:nodoc:
        @@hooks = Hash.new
        @@update_procs = Hash.new
        @@collide_side_methods = Hash.new(Hash.new())
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
              if sprite.visible and sprite.kind_of? klass and self.collide_sprite? sprite and self.visible and self != sprite
                self.send name, sprite
                self.call_collide_sides sprite
              end
            end
          }
          
        when "colliding bottom"
          self.add_colliding "bottom", parts
        when "colliding top"
          self.add_colliding "top", parts
        when "colliding left"
          self.add_colliding "left", parts
        when "colliding right"
          self.add_colliding "right", parts
        end
      
      end
      
      def merge_methods klass
        if superclass == Sprite
          return @@collide_side_methods[self][klass]
        end
        
        return @@collide_side_methods[self][klass].merge superclass.merge_methods(klass)
      end

      def colliding_side_methods
        methods = @@collide_side_methods[self]

        return_methods = Hash.new(Set.new [])

        methods.each do |klass, methods|
          return_methods[klass] = self.merge_methods klass
        end

        return return_methods
      end
      
      def add_colliding side, method_parts
        klass_name = method_parts[3..-1].join('_').intern
        
        methods = @@collide_side_methods[self][klass_name] 
        if methods == nil
          methods = Set.new []
        end
        methods.add side
        @@collide_side_methods[self][klass_name] = methods
        
        if @@update_procs[self]["collide_with_#{klass_name}"] == nil
          @@update_procs[self]["collide_with_#{klass_name}"] = proc {
            klass = Object.const_get klass_name
            EasyRubygame.active_scene.sprites.each do |sprite|
              sprite.update_rect
              if sprite.visible and sprite.kind_of? klass and self.collide_sprite? sprite and self.visible and self != sprite
                self.call_collide_sides sprite
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
