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

    attr_accessor :x, :y, :x_velocity, :y_velocity

    def initialize(img_src)
      super()
      @x = 0
      @y = 0
      @x_velocity = 0
      @y_velocity = 0
      @x_acceleration = 0
      @y_acceleration = 0
      @visible = true
      @sprites = []
      self.image = img_src

      @@update_procs[self.class] ||= []
      @@hooks[self.class] ||= Hash.new
      self.make_magic_hooks @@hooks[self.class]
    end
    
    def update
      return unless @visible
      
      @prev_x, @prev_y = @x, @y

      @x_velocity += @x_acceleration
      @y_velocity += @y_acceleration

      @x += @x_velocity
      @y += @y_velocity
      
      @@update_procs[self.class].each {|p| instance_eval &p}

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
        # ignore NoMethodErrors -- the subclass might not have defined
        # touch_* methods
      end

      @rect.topleft = @x, @y
      pass_frame if @visible
    end

    def onscreen?
      return !self.offscreen?
    end

    def offscreen?
      return (@x > EasyRubygame.window_width) || (@y > EasyRubygame.window_height) || (@x < -@rect.width) || (@y < -@rect.height)
    end

    def image= img_src
      @img_src = img_src
      @image = Surface[img_src]
      @rect = @image.make_rect
      @rect.topleft = @x, @y
    end

    def add_sprite name, file

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

      puts "parts: #{parts.inspect}, first_part: #{first_part.inspect}"

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
            if sprite.kind_of? klass and self.collide_sprite? sprite
              self.send name, sprite
            end
          end
        }
      end
    end
  end
end

EasyRubygame::Sprite.init
