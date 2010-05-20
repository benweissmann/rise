paddle_one = Paddle_left.new(0)
paddle_two = Paddle_right.new(490)
ball = Ball.new(200, 200, 5, 5)

main_scene = Scene.new
main_scene.sprites.push paddle_one, paddle_two, ball

EasyRubygame.active_scene = main_scene