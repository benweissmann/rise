player_paddle = Paddle.new(200, 480)
the_ball = Ball.new(8, 7)
def get_random_block
    possible_images = ["brick_blue.gif", "brick_green.gif", "brick_limegreen.gif",
      "brick_mint.gif", "brick_orange.gif", "brick_pink.gif", "brick_purple.gif",
      "brick_red.gif", "brick_salmon.gif", "brick_skyblue.gif", "brick_yellow.gif"]
    return possible_images[rand(possible_images.length)]
end

main_scene = Scene.new
main_scene.background = :white
main_scene.sprites.push(the_ball)

0.step 100, 18 do |y|
  @current_color = get_random_block
  0.step 500, 36 do |x|
    main_scene.sprites.push(Block.new(x, y, @current_color, 1))
  end
end

EasyRubygame.active_scene = main_scene