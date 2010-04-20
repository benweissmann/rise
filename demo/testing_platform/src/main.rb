# This should hold main initialization logic

txt = EasyRubygame::TextSprite.new :text => 'foo', :size => 200
ball = Ball.new(100, 50, 11, 10)

puts "hello world"

main_scene = Scene.new
main_scene.sprites.push ball, txt
EasyRubygame.active_scene = main_scene
