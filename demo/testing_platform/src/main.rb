# This should hold main initialization logic

txt = EasyRubygame::TextSprite.new :text => 'foo', :size => 200
txt.size = 20
txt.wait(30) do
  self.size = 200
end

EasyRubygame.storage[:hello] = "world"
ball = Ball.new(100, 50, 3, 3)
floor = Floor.new(0, 250)
main_scene = Scene.new :green
second_scene = Scene.new
second_scene.sprites.push ball, floor

EasyRubygame.storage[:ss] = second_scene

ball.wait 30 do 
  EasyRubygame.active_scene = EasyRubygame.storage[:ss]
end

main_scene.sprites.push ball, floor
EasyRubygame.active_scene = main_scene
