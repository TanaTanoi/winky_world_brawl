class RagdollPlayer

  def initialize(window: window, controls: controls, pos: pos)
    @window = window
    @controls = controls

    @ragdoll = Ragdoll.new(window, pos)
  end

  def draw
    @ragdoll.draw
  end

  def update
    move
    @ragdoll.update
  end

  def move
    move_left if @window.button_down?(@controls[:left])
    move_right if @window.button_down?(@controls[:right])
    move_up if @window.button_down?(@controls[:up])
    move_down if @window.button_down?(@controls[:down])
  end

  private

  def move_left
    @ragdoll.move_left
  end

  def move_right
      @ragdoll.move_right
  end

  def move_up
      @ragdoll.move_up
  end

  def move_down
      @ragdoll.move_down
  end
end
