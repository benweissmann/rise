ship = Ship.new(250)

list_of_enemies = []

main_scene = Black.new

11.times do |x_cord|
  list_of_enemies.push(Enemy1.new(45+30*x_cord, 30))
  list_of_enemies.push(Enemy2.new(42+30*x_cord, 30+30))
  list_of_enemies.push(Enemy2.new(42+30*x_cord, 30+60))
  list_of_enemies.push(Enemy3.new(42+30*x_cord, 30+90))
  list_of_enemies.push(Enemy3.new(42+30*x_cord, 30+120))
  
end

controller = Enemy_Controller.new(8, 20, list_of_enemies)


main_scene.sprites.push(controller, ship)

list_of_enemies.each do |enemy|
  main_scene.sprites.push(enemy)
end

EasyRubygame.active_scene = main_scene