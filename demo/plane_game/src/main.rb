# This should hold main initialization logic
controller = Controller.new
player = Plane.new(250, 400)

main_scene = Black.new
main_scene.sprites.push(controller, player)
EasyRubygame.active_scene = main_scene
