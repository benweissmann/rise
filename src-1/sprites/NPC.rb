class NPC < Sprite
  attr_reader :text

  def initialize (text)
    super "person.gif"

    @text = text
  end
end
