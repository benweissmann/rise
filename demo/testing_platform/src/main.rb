# This should hold main initialization logic

txt = EasyRubygame::TextSprite.new :text => 'foo', :size => 200
txt.size = 20
txt.wait(30) do
  self.size = 200
end

EasyRubygame.storage[:hello] = "world"
ball = Ball.new(100, 50, 3, 3)
main_scene = Scene.new :aqua
main_scene.sprites.push ball
EasyRubygame.active_scene = main_scene
