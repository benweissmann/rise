module ERB_Sounds
  
  def ERB_Sounds.init
    @sounds = {}
  end
  
  class << self
    
    # loads a sound. name should be a symbol, 
    # and file_loc is the location relative to
    # sounds/
    # from some brief experimentation, wav files 
    # work and I couldn't get an mp3 to work
    def add name, file_loc
      sound = Sound.autoload(file_loc)
      
      #throws nice execption
      if nil == sound
        raise "Could not find the sound #{file_loc}."
      end
      @sounds[name] = sound
    end
    
    # play a sound, give an optional opitions array
    # note that :repeats => 1 will play the file twice
    # and :stop_after ovirrides any repeats
    def play name, options={:fade_in => 0, :repeats => 0, :stop_after => nil}
      @sounds[name].play( options)
    end
    
    # is the sound not stopped and not paused?
    def playing? name
      return @sounds[name].playing?
    end
    
    # make the sound fade out. if it's currently
    # paused, nothing will sound (you will hear it
    # once you play again)
    def fade_out name, time
      @sounds[name].fade_out(time)
    end
    
    # in a sound currently fading?
    # optional parm for direciton: :in, :out, :either
    def fading? name
      return @sounds[name].fading?
    end
    
    # pause the sound where it is. saves its state
    def pause name
      @sounds[name].pause
    end
    
    # is the sound currently paused?
    def paused? name
      return @sounds[name].paused?
    end
    
    # resume playing where left off from. 
    def unpause name
       @sounds[name].unpause
     end
    
    # stops the sound, will resume again from the start
    def stop name
      @sounds[name].stop
    end
    
    # is it not-paused and not-playing?
    def stopped? name
      return @sounds[name].stopped?
    end
    
    # get the current volume
    # volume is a float between 0 and 1
    def volume name
      @sounds[name].volume
    end
    
    # set the current volume to a float
    # between 0 and 1. you cannot set the 
    #volume if you are currently fading in or out 
    def volume=(name, new_vol)
      @sounds[name].volume = new_vol
    end
  end
  
end