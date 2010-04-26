# This should hold main initialization logic

txt = EasyRubygame::TextSprite.new :text => 'foo', :size => 200
txt.size = 20
txt.wait(30) do
  self.size = 200
end

EasyRubygame.storage[:hello] = "world"
ball = Ball.new(100, 50, 0, 0)

ERB_Sounds.add(:doh, "doh.wav")
ERB_Sounds.play(:doh, {:repeats => 5})

ERB_Sounds.fade_out :doh, 3

floor = Floor.new(0, 300)

main_scene = Scene.new
main_scene.sprites.push ball, floor
EasyRubygame.active_scene = main_scene
