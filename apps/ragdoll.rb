
class Ragdoll
  attr_accessor :torso
  def initialize(window, pos)
    @torso = RagdollTorso.new(window,pos)
  end

  MOVE_AMOUNT = 5

  def move_up
    move_by vec2(0,-MOVE_AMOUNT)
  end

  def move_down
    move_by vec2(0, MOVE_AMOUNT)
  end

  def move_left
    move_by vec2(-MOVE_AMOUNT, 0)
  end

  def move_right
    move_by vec2(MOVE_AMOUNT, 0)
  end

  def move_by(vector = vec2(0,0))
    @torso.body.v+=vector
  end


  def draw
    @torso.draw
  end

  def update
    @torso.update
  end

end
