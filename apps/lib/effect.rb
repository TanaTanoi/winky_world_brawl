class Effect
  EFFECT_LOCATION  = 'assets/effects/'

  attr_reader :decay

  def self.load_image(window, type)
    @powerup_images = Gosu::Image.new(window, EFFECT_LOCATION + type + ".png", false)
  end

  def initialize(type:, pos:, window:)
    @pos = pos
    @type = type
    @window = window
    if type == :explosion
      @effect_image = self.class.load_image(window, type.to_s)
      @width = @effect_image.width
      @height = @effect_image.height
    end

    play_effect

    @decay = 100
  end

  def update
    @decay -= 1
  end

  def draw
    if @decay > 0
      draw_effect
    end
  end

  private

  def play_effect
    case @type
    when :explosion
      Gosu::Sample.new(EFFECT_LOCATION + "explosion.mp3").play
    when :shield
      Gosu::Sample.new(EFFECT_LOCATION + "shield.ogg").play
    when :money
      Gosu::Sample.new(EFFECT_LOCATION + "money.mp3").play
    end
  end

  def draw_effect
    case @type
    when :explosion
      top_left_x, top_left_y, bottom_right_x, bottom_right_y = top_left_and_bottom_right
      @window.draw_image_rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y, @effect_image, ZOrder::Effect)

      @width += 1
      @height += 1
    end
  end

  def top_left_and_bottom_right
    [@pos.x - @width, @pos.y - @height, @pos.x + @width, @pos.y + @height]
  end
end
