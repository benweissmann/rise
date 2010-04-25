module ERB_Sounds
  
  def ERB_Sounds.init
    @sounds = {}
  end
  
  class << self
    def add name, file_loc
      sound = Sound.autoload(file_loc)
      if nil == sound
        throw "Could not find the sound #{file_loc}."
      end
      @sounds[name] = sound
    end
    
    def play name, options={:fade_in => 0, :repeats => 0, :stop_after => nil}
      @sounds[name].play( options)
    end
    
    def fade name, time
      @sounds[name].fade_out(time)
    end
    
    def fading? name
      return @sounds[name].fading?
    end
    
    def pause name
      @sounds[name].pause
    end
    
    def paused? name
      return @sounds[name].paused?
    end
    
    def stop name
      @sounds[name].stop
    end
    
    def stopped? name
      return @sounds[name].stopped?
    end
    
    def unpause name
      @sounds[name].unpause
    end
    
    def volume name
      @sounds[name].volume
    end
    
    def volume=(name, new_vol)
      @sounds[name].volume = new_vol
    end
  end
  
end