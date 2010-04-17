# This should hold main initialization logic

txt = EasyRubygame::TextSprite.new :text => 'foo', :size => 200
ball = Ball2.new(100, 50, 11, 10)

main_scene = Scene.new
main_scene.sprites.push ball, txt
EasyRubygame.active_scene = main_scene
