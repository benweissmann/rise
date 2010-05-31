ship = Ship.new(250)

#the controller needs an array of all the enimies
list_of_enemies = []

main_scene = Black.new

#since the rows have different enemies, I just push 5 enemies
#at once and iterate through the x_cord
11.times do |x_cord|
  list_of_enemies.push(Enemy1.new(45+30*x_cord, 30))
  list_of_enemies.push(Enemy2.new(42+30*x_cord, 30+30))
  list_of_enemies.push(Enemy2.new(42+30*x_cord, 30+60))
  list_of_enemies.push(Enemy3.new(42+30*x_cord, 30+90))
  list_of_enemies.push(Enemy3.new(42+30*x_cord, 30+120))
end

controller = Enemy_Controller.new(8, 20, list_of_enemies)

main_scene.sprites.push(ship, controller)

#the enemies still need to be pushed on screen at some point
list_of_enemies.each do |enemy|
  main_scene.sprites.push(enemy)
end


RISE.active_scene = main_scene