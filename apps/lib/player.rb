class Player
  SPRITE_LOCATION  = 'assets/sprites/player.png'
  INITIAL_SPEED = 5

  attr_reader :speed, :x, :y

  def self.load_image(window)
    @player_image ||= Gosu::Image.new(window, 'assets/sprites/player.png', false)
  end

  def initialize(window)
    @player_image = self.class.load_image(window)
    @window = window

    @x = window.width / 2
    @y = window.height / 2
    @speed = INITIAL_SPEED
    @x_offset = @player_image.width / 2
    @y_offset = @player_image.height / 2
  end

  def draw
    @player_image.draw_rot(@x, @y, ZOrder::Player, 0)
  end

  def update
    move
  end

  def move #TODO map of controls
    if @window.button_down?(Gosu::KbLeft) || @window.button_down?(Gosu::GpLeft)
      move_left
    end

    if @window.button_down?(Gosu::KbRight) || @window.button_down?(Gosu::GpRight)
      move_right
    end

    if @window.button_down?(Gosu::KbUp) || @window.button_down?(Gosu::GpUp)
      move_up
    end

    if @window.button_down?(Gosu::KbDown) || @window.button_down?(Gosu::GpDown)
      move_down
    end
  end

  private

  def move_left
    if @x > 0 + @x_offset
      @x -= @speed
    end
  end

  def move_right
    if @x < @window.width - @x_offset
      @x += @speed
    end
  end

  def move_up
    if @y > 0 + @y_offset
      @y -= @speed
    end
  end

  def move_down
    if @y < @window.height - @y_offset
      @y += @speed
    end
  end
end

