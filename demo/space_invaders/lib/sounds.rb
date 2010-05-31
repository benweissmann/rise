module RISE
  # Controlls playback of sound effect, music tracks, and other
  # sounds. Provides functionality to play/pause/stop sounds,
  # manipulate volume, and fade tracks in and out.
  module Sounds
    class << self
      def init #:nodoc:
          @sounds = {}
      end
      
      # Loads a sound.
      # 
      # +name+:: Name of the sound as a Symbol, as it will be
      #          referred to in Sound.play
      # +file+:: Name of file in resources/sounds/ as a String
      #
      # Not that the sound tile types that work varies by system.
      # Preliminary experiments have found success with .wav files.
      def add name, file
        sound = Sound.autoload(file)
        
        #throws nice execption
        if sound.nil?
          raise "Could not find the sound #{file}."
        end
        @sounds[name] = sound
      end
      
      # Plays a sound.
      #
      # <code>options</code>:: Hash of options
      # <code>options[:fade_in]</code>:: If specified, the sound will face in over this
      #                       many seconds.
      # <code>options[:repeats]</code>:: Repeat this song this many times. Note that a
      #                       value of 1 will play the sound twice, a value
      #                       of 2 will play it thrice, etc.
      # <code>options[:stop_after]</code>:: If specified, the sound will stop playing
      #                          after this many seconds.
      def play name, options={:fade_in => 0, :repeats => 0, :stop_after => nil}
        @sounds[name].play( options)
      end
      
      # Is the sound not stopped and not paused?
      def playing? name
        return @sounds[name].playing?
      end
      
      # Causes the sound referenced by +name+ to fade out. Note that you
      # won't hear anything unless that wound it currently playing. The fade
      # will occur over the number of seconds specified by +time+.
      def fade_out name, time
        @sounds[name].fade_out(time)
      end
      
      # Determines if the sound referenced by +name+ is currently
      # fading.
      #
      # +direction+ is an optional parameter that sets the direcion of
      # the fade you're looking for. It can be :in, :out, or :either,
      # and defaults to :either. So if the sound +:foo+ is fading out,
      # and you call <code>Sounds.fading? :foo, :in</code>, you will
      # get +false+.
      def fading? name, direction = :either
        return @sounds[name].fading?
      end
      
      # Pauses the sound referenced by +name+. When this sound is
      # restarted by Sounds.unpause, it will resume from where it was
      # when it was paused.
      def pause name
        @sounds[name].pause
      end
      
      # Determines if the sound reference by +name+ is currently
      # paused.
      def paused? name
        return @sounds[name].paused?
      end
      
      # Resumes playing a sound that was paused with Sounds.pause.
      def unpause name
         @sounds[name].unpause
       end
      
      # Stops a sound. When the sound is started with Sounds.play,
      # it will begin from the start of the sound.
      def stop name
        @sounds[name].stop
      end
      
      # Is the sound stopped (not paused and not playing)?
      def stopped? name
        return @sounds[name].stopped?
      end
      
      # Get the volume of a sound. It will be a float between 0 and
      # 1.
      def volume name
        @sounds[name].volume
      end
      
      # Set the volume of a sound. +new_vol+ should be a float
      # between 0 and 1. You cannot set the volume of a sound that
      # is currently fading.
      def volume= name, new_vol
        @sounds[name].volume = new_vol
      end
    end
  end
end

RISE::Sounds.init
