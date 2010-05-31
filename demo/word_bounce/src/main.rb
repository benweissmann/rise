# This should hold main initialization logic
txt = BouncyText.new("Hello World!")
scene = Scene.new
scene.sprites.push(txt)

RISE.active_scene = scene
