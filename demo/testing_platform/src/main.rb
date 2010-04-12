# This should hold main initialization logic

ball = Ball.new(100, 50, 11, 10)

main_scene = Scene.new
main_scene.sprites.push ball
EasyRubygame.active_scene = main_scene