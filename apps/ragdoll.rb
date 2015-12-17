
class Ragdoll
  attr_accessor :torso
  def initialize(window, pos)
    @torso = RagdollTorso.new(window,pos)
  end


  def draw
    @torso.draw
  end

  def update
    @torso.update
  end
end
