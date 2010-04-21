# This should hold main initialization logic
txt = BouncyText.new("Hello World!")
scene = Scene.new
scene.sprites.push(txt)

EasyRubygame.active_scene = scene
