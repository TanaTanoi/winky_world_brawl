class KingHill
  SPRITE_LOCATION  = 'assets/sprites/hill.png'

  VELOCITY_RANGE = 1..5

  def self.load_image(window)
    @hill_image ||= Gosu::Image.new(window, SPRITE_LOCATION, false)
  end

  def initialize(window)
    @hill_image = self.class.load_image(window)
    @window = window
    @width = window.width / 10
    @height = window.height / 10
    @x_offset = @hill_image.width / 2
    @y_offset = @hill_image.height / 2

    initial_hill_position
    initial_hill_velocity
  end

  def update
    update_position
  end

  def draw
    @hill_image.draw_rot(@x, @y, ZOrder::Hill, 0)
  end

  private

  def initial_hill_position
    @x = @window.width / 2
    @y = @window.height / 2
  end

  def initial_hill_velocity
    @x_velocity = [-random_velocity, random_velocity].sample
    @y_velocity = [-random_velocity, random_velocity].sample
  end

  def update_position
    @x += @x_velocity
    @y += @y_velocity

    check_bounds
  end

  def check_bounds
    if @x < @x_offset
      @x_velocity = random_velocity
    elsif @x > @window.width - @x_offset
      @x_velocity = -random_velocity
    end

    if @y < @y_offset
      @y_velocity = random_velocity
    elsif @y > @window.height - @y_offset
      @y_velocity = -random_velocity
    end
  end

  def random_velocity
    rand(VELOCITY_RANGE)
  end
end
