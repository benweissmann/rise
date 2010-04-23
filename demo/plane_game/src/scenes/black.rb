# scene with a black background
class Black < Scene
  
  def initialize()
    super()
    # There will be a better way to do this in the near future
    @background.fill([0,0,0])
  end
end
