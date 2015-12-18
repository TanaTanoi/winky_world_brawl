class Powerup
  SPRITE_LOCATION  = 'assets/sprites/'
  BOMB_RANGE = (-20..20)

  POWERUPS = [
    :bomb,
    :shield
  ]

  POWERUP_SPRITES = {
    bomb: "bomb.png",
    shield: "shield.png"
  }

  def self.load_image(window)
    @powerup_images ||= Hash[self.powerup_images_array(window)]
  end

  def self.powerup_images_array(window)
    POWERUPS.map do |powerup|
        [powerup, Gosu::Image.new(window, SPRITE_LOCATION+POWERUP_SPRITES[powerup], false)]
     end
  end

  def initialize(window, pos, power, size: 50)
    @powerup_images = self.class.load_image(window)
    @window = window
    @pos = pos
    @power = power
    @size = size
    # Powerup.load_image(window)
  end

  def touching?(player)
    @pos.dist(player.ragdoll.body.p) < @size
  end

  def update
  end

  def activate(player)
    send(@power, player)
  end

  def draw
    top_left_x, top_left_y, bottom_right_x, bottom_right_y = top_left_and_bottom_right
    @window.draw_image_rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y, @powerup_images[@power], ZOrder::Powerup)
  end

  def bomb(player)
    player.body.v = vec2(rand(BOMB_RANGE),rand(BOMB_RANGE))
  end

  def top_left_and_bottom_right
    [@pos.x - half_size, @pos.y - half_size, @pos.x + half_size, @pos.y + half_size]
  end

  def half_size
    @size/2
  end

end
