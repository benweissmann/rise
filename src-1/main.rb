def store_scene(scene)
  EasyRubygame.storage[scene.name] = scene
end

new_rock_hero = Player.new

crossroads = Named_Scene.new(:crossroads, "BG3.jpg")

green_r_d = Named_Scene.new(:green_r_d, "BG2.jpg")

green_l_d_r = Named_Scene.new(:green_l_d_r, "BG.jpg")

red_r_d = Named_Scene.new(:red_r_d, "BG_bee.jpg")

blue_l_d = Named_Scene.new(:blue_l_d, "BG_IceFlower.jpg")

grey_u_l = Named_Scene.new(:grey_u_l, "BG_Metal_Tree.jpg")


thingy = Enemy.new(400, 300, new_rock_hero)

sword = Weapon.new(new_rock_hero)

crossroads.sprites.push new_rock_hero, sword, thingy
green_r_d.sprites.push new_rock_hero, sword, thingy
green_l_d_r.sprites.push new_rock_hero, sword, thingy
red_r_d.sprites.push new_rock_hero, sword, thingy
blue_l_d.sprites.push new_rock_hero, sword, thingy
grey_u_l.sprites.push new_rock_hero, sword, thingy

store_scene(crossroads)
store_scene(green_r_d)
store_scene(green_l_d_r)
store_scene(red_r_d)
store_scene(blue_l_d)
store_scene(grey_u_l)

EasyRubygame.active_scene = crossroads


