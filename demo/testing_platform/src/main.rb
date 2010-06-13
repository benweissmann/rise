# This should hold main initialization logic


txt = RISE::TextSprite.new :text => 'foo', :size => 200, :color => ({:r => 0.3, :g => 0.7, :b => 0.5})
txt.size = 20
txt.wait(30) do
  self.size = 200
end

RISE.storage[:hello] = "world"
ball = Ball.new 20, 50, 1, 1
floor = Floor.new(100, 250)
floor2 = Floor.new(100, 350)
floor3 = Floor.new(50, 50)
floor4 = Floor.new(225, 150)
main_scene = Scene.new :green



Timer.wait 30 do
  puts 'waited 30 frames'
end

Timer.wait 60 do
  puts 'waited 60 frames'
end


ms = Timer.wait 1000, :ms do 
  puts 'waited 1000 ms'
end

ms.clear

Timer.wait 1, :seconds do
  puts 'waited 1 second'
end

hours = Timer.wait 0.005, :hours do
  puts 'waited .005 hours'
end

Timer.wait 0.1, :minutes do
  puts 'waited .1 minutes'
  hours.finish
end

s_down = lambda do
  RISE.keys[:s]
end

s = Timer.whenever s_down do
  puts 's is down'
end

t_down = lambda do
  RISE.keys[:d]
end

Timer.when t_down do
  s.finish
end

class Foo
  def bar
    puts 'Foo#bar'
  end
end

foo = Foo.new

e = Timer.every 2, :seconds, [foo, :bar]

f_down = lambda do
  RISE.keys[:f]
end

Timer.when f_down, [e, :clear]

g_down = lambda do
  puts 'checked g'
  RISE.keys[:g].tap {|o| puts o}
end

Timer.when g_down do
  puts 'gee! You pressed a "g"!'
  e.clear
end




main_scene.sprites.push ball, floor, floor2, floor3, floor4
RISE.active_scene = main_scene
