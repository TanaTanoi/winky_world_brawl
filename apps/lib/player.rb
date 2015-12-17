class Player
  SPRITE_LOCATION  = 'assets/sprites/player.png'
  INITIAL_SPEED = 5

  attr_reader :speed, :x, :y

  def self.load_image(window)
    @player_image ||= Gosu::Image.new(window, 'assets/sprites/player.png', false)
  end

  def initialize(window: window, controls: controls)
    @player_image = self.class.load_image(window)
    @window = window
    @controls = controls

    @direction = 0 # 0 => up, 1 => right, 2 => down, 3 => left

    @x = window.width / 2
    @y = window.height / 2
    @speed = INITIAL_SPEED
    @x_offset = @player_image.width / 2
    @y_offset = @player_image.height / 2
  end

  def draw
    @player_image.draw_rot(@x, @y, ZOrder::Player, @direction * 90)
  end

  def update
    move
  end

  def move
    move_left if @window.button_down?(@controls[:left])
    move_right if @window.button_down?(@controls[:right])
    move_up if @window.button_down?(@controls[:up])
    move_down if @window.button_down?(@controls[:down])
  end

  private

  def move_left
    if @x > 0 + @x_offset
      @x -= @speed
    end

    @direction = 3
  end

  def move_right
    if @x < @window.width - @x_offset
      @x += @speed
    end

    @direction = 1
  end

  def move_up
    if @y > 0 + @y_offset
      @y -= @speed
    end

    @direction = 0
  end

  def move_down
    if @y < @window.height - @y_offset
      @y += @speed
    end

    @direction = 2
  end
end
