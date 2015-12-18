class Player
  SPRITE_LOCATION  = 'assets/sprites/'
  WHITE = Gosu::Color.argb(0xff_ffffff)
  GREY =  Gosu::Color.argb(0xff_999999)
  attr_reader :ragdoll, :score, :id, :effects

  def self.load_images(window, id)
    [
      @player_image = Gosu::Image.new(window, SPRITE_LOCATION + "player#{id}.png", false),
      @player_disabled_image ||= Gosu::Image.new(window, SPRITE_LOCATION + "disabled.png", false)
    ]
  end

  def initialize(window:, controls:, pos:, id:)
    @player_image, @disabled_image = self.class.load_images(window, id)
    @id = id
    @window = window
    @controls = controls
    @effects = { disabled: 0, shield: false }
    @score = 0
    @ragdoll = Ragdoll.new(window, pos)
  end

  def draw
    color = ( @effects[:shield] ? GREY : WHITE )
    draw_player(@player_image, color)

    if @effects[:disabled] > 0
      draw_player(@disabled_image)
    end
  end

  def update
    if @effects[:disabled] > 0
      disabled_tick
    else
      move
      @ragdoll.update
    end
  end

  def disable(count)
    @effects[:disabled] += count
  end

  def add_score(score)
    @score += score
  end

  private

  def draw_player(image, color = WHITE)
    top_left, top_right, bottom_left, bottom_right = @ragdoll.rotate

    # Gotta draw things back to front because we're in space so that makes sense right? TODO prove this in real life
    image.draw_as_quad(bottom_left.x, bottom_left.y, color, bottom_right.x, bottom_right.y, color,
                              top_left.x, top_left.y, color, top_right.x, top_right.y, color, 1)
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
    @effects[:disabled] -= 1
  end
end
