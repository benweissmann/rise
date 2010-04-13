ship = Ship.new(250)

list_of_enemies = []

main_scene = Black.new

11.times do |x_cord|
  list_of_enemies.push(Enemy1.new(95+30*x_cord, 40))
  #list_of_enemies.push(Enemy2.new(92+30*x_cord, 40+30))
  #list_of_enemies.push(Enemy2.new(92+30*x_cord, 40+60))
  #list_of_enemies.push(Enemy3.new(92+30*x_cord, 40+90))
  #list_of_enemies.push(Enemy3.new(92+30*x_cord, 40+120))
  
end

controller = Enemy_Controller.new(8, 20, list_of_enemies)


main_scene.sprites.push(controller, ship)

list_of_enemies.each do |enemy|
  main_scene.sprites.push(enemy)
end

EasyRubygame.active_scene = main_scene