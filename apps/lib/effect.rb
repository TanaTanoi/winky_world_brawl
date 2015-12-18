class Effect
  EFFECT_LOCATION  = 'assets/effects/'

  attr_reader :decay

  def self.load_image(window, type)
    @powerup_images ||= Gosu::Image.new(window, EFFECT_LOCATION + type + ".png", false)
  end

  def initialize(type: type, pos: pos, window: window)
    @pos = pos
    @type = type
    @window = window
    @effect_image = self.class.load_image(window, type.to_s)

    @width = @effect_image.width
    @height = @effect_image.height

    @decay = 100
  end

  def update
    @decay -= 1
  end

  def draw
  end
  def draw
    if @decay > 0
      draw_effect
    end
  end

  private

  def draw_effect
    top_left_x, top_left_y, bottom_right_x, bottom_right_y = top_left_and_bottom_right
    @window.draw_image_rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y, @effect_image, ZOrder::Effect)

    @width += 1
    @height += 1
  end

  def top_left_and_bottom_right
    [@pos.x - @width, @pos.y - @height, @pos.x + @width, @pos.y + @height]
  end
end