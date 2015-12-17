class Player
  SPRITE_LOCATION  = 'assets/sprites/player.png'
  INITIAL_SPEED = 2

  attr_reader :speed, :x, :y

  def self.load_image(window)
    @player_image ||= Gosu::Image.new(window, SPRITE_LOCATION, false)
  end

  def initialize(window: window, controls: controls, pos: pos)
    @player_image = self.class.load_image(window)
    @window = window
    @controls = controls




    @direction = 0 # 0 => up, 1 => right, 2 => down, 3 => left

    @x = window.width / 2
    @y = window.height / 2
    #@x_offset = @player_image.width / 2
    #@y_offset = @player_image.height / 2

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

  def move_left1
    if @x > 0 + @x_offset
      @x -= @speed
    end

    if @direction == 3
      @speed += 1
    else
      @speed = INITIAL_SPEED
    end

    @direction = 3
  end

  def move_right1
    if @x < @window.width - @x_offset
      @x += @speed
    end

    if @direction == 1
      @speed += 1
    else
      @speed = INITIAL_SPEED
    end

    @direction = 1
  end

  def move_up1
    if @y > 0 + @y_offset
      @y -= @speed
    end

    if @direction == 0
      @speed += 1
    else
      @speed = INITIAL_SPEED
    end

    @direction = 0
  end

  def move_down1
    if @y < @window.height - @y_offset
      @y += @speed
    end

    if @direction == 2
      @speed += 1
    else
      @speed = INITIAL_SPEED
    end

    @direction = 2
  end
end

