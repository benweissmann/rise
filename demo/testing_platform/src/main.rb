# This should hold main initialization logic

ball = Ball.new(100, 50, 11, 10)
txt = EasyRubygame::TextSprite.new :text => 'foo', :size => 50



main_scene = Scene.new
main_scene.sprites.push ball, txt
EasyRubygame.active_scene = main_scene
