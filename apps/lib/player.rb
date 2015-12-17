class Player
  SPRITE_LOCATION  = 'assets/sprites/'
  WHITE = Gosu::Color.argb(0xff_ffffff)

  attr_reader :ragdoll

  def self.load_images(window)
    [
      @player_image ||= Gosu::Image.new(window, SPRITE_LOCATION + 'player.png', false),
      @player_disabled_image ||= Gosu::Image.new(window, SPRITE_LOCATION + 'player_disabled.png', false)
    ]
  end

  def initialize(window: window, controls: controls, pos: pos)
    @player_image, @player_disabled_image = self.class.load_images(window)

    @window = window
    @controls = controls

    @disabled = 0

    @ragdoll = Ragdoll.new(window, pos)
  end

  def draw
    if @disabled > 0
      draw_player(@player_disabled_image)
    else
      draw_player(@player_image)
    end
  end

  def update
    if @disabled > 0
      disabled_tick
    else
      move
      @ragdoll.update
    end
  end

  def disable(count)
    @disabled += count
  end

  private

  def draw_player(image)
    top_left, top_right, bottom_left, bottom_right = @ragdoll.rotate

    # Gotta draw things back to front because we're in space so that makes sense right?
    image.draw_as_quad(bottom_left.x, bottom_left.y, WHITE, bottom_right.x, bottom_right.y, WHITE,
                              top_left.x, top_left.y, WHITE, top_right.x, top_right.y, WHITE, 1)
  end

  def move
    move_left if @window.button_down?(@controls[:left])
    move_right if @window.button_down?(@controls[:right])
    move_up if @window.button_down?(@controls[:up])
    move_down if @window.button_down?(@controls[:down])
  end

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

  def disabled_tick
    @disabled -= 1
  end
end
