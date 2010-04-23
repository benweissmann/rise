# create sprites
controller = Controller.new
player = Plane.new(250, 400)

# scene with black background
main_scene = Black.new

# add sprites to scene and set as active scene
main_scene.sprites.push(controller, player)
EasyRubygame.active_scene = main_scene
