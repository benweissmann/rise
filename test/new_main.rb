paddle_one = Paddle.new(:up, :down, 0, 225)
paddle_two = Paddle.new(:left, :right, 490, 225)
ball = Ball.new(250, 250, 2, 2, paddle_one, paddle_two)

main_scene = Scene.new
main_scene.sprites.push paddle_one, paddle_two, ball
EasyRubygame.active_scene = main_scene