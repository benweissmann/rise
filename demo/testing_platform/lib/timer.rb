# The Timer class serves two purposes:
# 
# - It's the base class for all timers -- e.g. TimeTimer and
#   FrameTimer. Timer execute code when a condition is met,
#   such as a number of frames passing, or a certain
#   amount of time passing. All subclasses of Timer MUST define a
#   pass_frame method. This method is called each frame, and should
#   call Timer#finish when the Timer's condition is met. Subclasses
#   should also implement a reset method, if reasonable.
# - It also acts as a namespace for several a bunch of
#   methods that instantiate Timers. In general, it's easier
#   to us Timer's class methods than directly instantiate Timers.
class Timer
  # Array of the TimerHandlers that will be executed when the Timer
  # finishes.
  attr_accessor :handlers

  # Creates a new Timer. Should be given a handler either as an
  # argument or as a block (not both). The argument handler can
  # be either a TimerHandler, a Proc, or an Array where the first
  # element is an Object and the second element is a symbol
  # representing a method that will be called on the Object.
  def initialize handler=nil, &block_handler
    @handlers = [TimerHandler.new(handler, &block_handler)]
    
    @id = Timer.each_frame do
      pass_frame
    end
  end

  def pass_frame #:nodoc:
    raise NotImplementedError, "Timer#each_frame MUST be overriden by a subclass"
  end

  # Resets this timer to its starting state. Not avaialbe for all
  # timers; see individual Timer subclasses for details on function
  # and availability.
  def reset
    raise NotImplementedError, "This Timer does not implement #reset."
  end

  # Stops this timer without executing its handlers.
  def clear
    Timer.clear @id
  end

  # Stops this timer, executing its handlers.
  def finish
    @handlers.each {|handler| handler.call}
    clear
  end

  # Adds an additional handler that will be executed when this timer
  # finishes. The handler is accepted in the same way as Timer.new.
  def add_handler handler=nil, &block_handler
    puts "handlers: #{@handlers.inspect}"
    @handlers.push TimerHandler.new(handler, &block_handler)
  end

  class << self
    # Sets up some class variables.
    def init #:nodoc:
      @@each_frame_blocks = {}
      @@next_block_id = 0
    end

    # Waits the specified amount of time or frames, then
    # executes a handler. Returns the TimeTimer or FrameTimer.
    #
    # +length+ :: The number of frames or time increments to wait.
    # +type+ :: The unit used by length. Can be +:frames+,
    #         +:miliseconds+, +:seconds+, +:minutes+, +:hours+, or the
    #         singular for of any of the above. +:ms+ may be used for
    #         +:miliseconds+, and +:s+ may be used for +:seconds+.
    # +handler+, +block_handler+ :: See Timer.new for handler formats.
    #
    # Examples:
    #
    #   Timer.wait 4, :seconds do
    #     puts 'I waited 4 seconds to do this'
    #   end
    #
    #   # Calls my_obj.some_method after 1 minute
    #   Timer.wait 1, :minute, [my_obj, :some_method]
    #
    #   handler = lambda { puts 'I waited 42 frames.' }
    #   Timer.wait 42, :frames, handler
    def wait length, type=:frames, handler=nil, &block_handler
      return make_factory(length, type, handler, &block_handler).call
    end

    # Periodically executes a handler. Identical to Timer.wait, but
    # executes repeatedly, rather than 1. See Timer.wait for
    # descriptions of the arguments. Returns a TimerRepeater that
    # contains a TimeTimer or FrameTimer.
    def every length, type=:frames, handler=nil, &block_handler
      return TimerRepeater.new &make_factory(length, type, handler, &block_handler)
    end

    # Waits until a condition is met, then executes a handler. +cond+
    # can be specified in eiter of thhe formats for a parameter
    # handler described in Timer.new, and must return a boolean.
    # When this boolean is true, the handler will be executed. The
    # handler is secified is the same way as in Timer.new.
    #
    # Examples:
    #
    #   k_pressed = lambda { RISE.keys[:k] }
    #   Timer.when k_pressed do
    #     puts 'K was pressd'
    #   end
    #
    #   my_array = ['foo', 'bar']
    #   Timer.when [my_array, :empty?] do
    #     puts 'my_array is empty.'
    #   end
    #   my_array.clear # This would make the Timer finish.
    def when cond, handler=nil, &block_handler
      return ConditionalTimer.new cond, handler, &block_handler
    end

    # Executes a handler whenever a condition is complete. Identical
    # to Timer.when, but executes the handler every frame the
    # condition is met, rather than only once. See Timer.when
    # for a description of the arguments. Returns a TimerRepeater that
    # contians a ConditionalTimer.
    def whenever cond, handler=nil, &block_handler
      return TimerRepeater.new do
        ConditionalTimer.new cond, handler, &block_handler
      end
    end

    private

    # Creates a Proc suitable for the factory argument of a
    # TimerRepeater. The Proc returns a subclass of Timer.
    # See Timer.wait for argument descriptions.
    def make_factory length, type, handler, &block_handler
      case type
      when :frames, :frame
        return lambda {FrameTimer.new length, handler, &block_handler}
      when :miliseconds, :ms, :milisecond
        return lambda {TimeTimer.new length, handler, &block_handler}
      when :seconds, :s, :second
        return lambda {TimeTimer.new length*1_000, handler, &block_handler}
      when :minutes, :minute
        return lambda {TimeTimer.new length*60_000, handler, &block_handler}
      when :hours, :hour
        return lambda {TimeTimer.new length*3_600_000, handler, &block_handler}
      end
      raise ArgumentError, "Unrecognized wait type \"#{type}\""
    end

    public

    # Executes the given block each frame, indefinitely. Returns an
    # Integer id that can be used to stop execution via Timer.clear.
    def each_frame &block
      id = (@@next_block_id += 1)
      @@each_frame_blocks[id] = block
      return id
    end

    # Called each frame by the RISE main loop to make Timer.each_frame
    # work.
    def pass_frame #:nodoc:
      @@each_frame_blocks.values.each do |block|
        block.call
      end
    end

    # Stops execution of one or more blocks that were scheduled to run
    # via Timer.each_frame. Takes an unlimited number of Integer ids
    # that correspond to the blocks that should becancelled. These ids
    # are returned by each_frame when the block is scheduled.
    #
    # Example:
    #
    #   block_id = Timer.each_frame do
    #     puts 'Hey there!'
    #   end
    #   
    #   # sometime later, when the block is no longer needed
    #   Timer.clear block_id
    def clear *ids
      if ids.length >= 1
        ids.each {|id| @@each_frame_blocks.delete id}
      else
        @@each_frame_blocks = {}
      end
    end
  end
end

# A Timer that executes a block after a specified number of frames. In
# general, create FrameTimers using Timer.wait instead of
# FrameTimer.new.
class FrameTimer < Timer
  # The number of frames until the handler is executed. Can be changed
  # at any timer to adjust when the handler is executed.
  attr_accessor :frames_left
  
  # Creates a new FrameTimer. +frames+ is the number of frames until
  # the handler is executed. See Timer.new for handler formats.
  #
  # In general, create FrameTimers using Timer.wait instead of
  # FrameTimer.new.
  def initialize frames, handler=nil, &block_handler
    super handler, &block_handler
    @duration = frames
    restart
  end

  def pass_frame #:nodoc:
    @frames_left -= 1
    finish if @frames_left <= 0
  end

  # Resets +frames_left+ to the original number of frames passed to
  # FrameTimer.new.
  def restart
    @frames_left = @duration
  end
end

# A Timer that executes a block after a certain amount of time. In
# general, create TimeTimers using Timer.wait instead of
# TimeTimer.new.
class TimeTimer < Timer
  # The time (in seconds after the epoch) at which the handler will
  # be executed. Can be changed at any timer to adjust when the
  # handler is executed.
  attr_accessor :end_time

  # Creates a new TimeTimer that waits the specified number of
  # miliseconds. See Timer.new for handler formats.
  #
  # In general, create FrameTimers using Timer.wait instead of
  # FrameTimer.new.
  def initialize ms, handler=nil, &block_handler
    super handler, &block_handler
    @duration = ms
    restart
  end

  def pass_frame #:nodoc:
    finish if Time.now >= @end_time
  end

  # Sets +end_time+ to the current time plus the number of miliseconds
  # pssed to TimeTimer.new.
  def restart
    @end_time = Time.now + (@duration / 1000)
  end
end

# A more generic Timer that executed when an arbitrary handler
# evaluates to true.
#
# In general, use Timer.when instead of directly instantiating a
# ConditionalTimer.
#
# Note that ConditionalTimer does NOT implement a +reset+ method.
# Make sure you aren't working with a ConditionalTimer before
# using +reset+ polymorphically.
class ConditionalTimer < Timer
  # Creates a new ConditionalTimer. See Timer.when for descriptions
  # of the arguments.
  #
  # In general, use Timer.when instead of directly instantiating a
  # ConditionalTimer.
  def initialize conditional, handler, &block_handler
    super handler, &block_handler

    @handler = TimerHandler.new handler, &block_handler
    @cond = TimerHandler.new conditional
  end

  def pass_frame #:nodoc:
    finish if @cond.call
  end
end

# A wrapper around a Timer that makes the Timer execute repeatedly.
# For example, wrapping a TimeTimer would make its handler execute
# EVERY <i>n</i> seconds, rather that just once, and wrapping a
# ConditionalTimer would make its handler execute EVERY frame where
# the condition is met, rather than just once.
#
# Unless you have particularly complex needs, use Timer.every or
# Timer.whenever instead of instantiation a TimerRepeater directly.
#
# Note that this effect is achieved by adding an additional handler
# to the Timer, so Timers wrapped in a TimerRepeater will have one
# mre handler than you would expect.
class TimerRepeater
  # The current timer wrapped by this TimerRepeater. Note that this
  # Timer changes each timer the handler is executed.
  attr_reader :current_timer

  # Creates a new TimerRepeater. The +factory+ block must return
  # a subclass of Timer. This factory will be used to create the
  # timer that this TimerRepeater uses.
  def initialize &factory
    @factory = factory
    start_timer
  end

  private

  def start_timer
    @current_timer = @factory.call
    @current_timer.add_handler do
      start_timer
    end
  end

  public

  # Stops this TimerRepeater without executing the handler.
  def clear
    @current_timer.clear
  end

  # Finishes the current timer once, but continues repeating.
  def continue
    @current_timer.finish
  end

  # Finishes the current timer, and then stops repeating.
  def finish
    continue
    clear
  end
end

# Using to abstract over the various handler forms available.
class TimerHandler #:nodoc:
  def initialize handler, &block_handler
    @handler = handler || block_handler
  end

  def call
    case @handler
    when Array
      return @handler[0].send(@handler[1])
    when Proc, TimerHandler
      return @handler.call
    end
  end
end

Timer.init
