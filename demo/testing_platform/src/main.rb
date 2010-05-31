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

main_scene.sprites.push ball, floor, floor2, floor3, floor4
RISE.active_scene = main_scene
