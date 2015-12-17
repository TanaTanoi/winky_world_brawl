require 'gosu'
require_relative 'lib/player'
require_relative 'lib/zorder'

class GameWindow < Gosu::Window
  GAME_NAME = "Winky World Brawl"

  WHITE = Gosu::Color.argb(0xff_ffffff)

  FONT_LOCATION = "assets/fonts/"
  BACKGROUND_LOCATION = "assets/backgrounds/"

  attr_reader :width, :height
  attr_accessor :space
  def initialize(width: 640, height: 480, fullscreen: false)
    super(width, height, fullscreen)
    self.caption = GAME_NAME

    @width = width
    @height = height
    @fullscreen = fullscreen

    load_fonts
    load_images

    @player = Player.new(self)

    @counter = 0

    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0,10)

    @ragdoll = Ragdoll.new(self, CP::Vec2.new(width/2, height/2))


  end

  def update
    @counter += 1
    @player.update
    @ragdoll.torso.shape.body.reset_forces
    @ragdoll.update
    @space.step((1.0/60.0))
  end

  def draw
    @font.draw(@counter, 0, 0, 1)
    draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
    @player.draw
    @ragdoll.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def draw_rect(x1, y1, x2, y2, color = WHITE)
    Gosu::draw_quad(x1, y1, color, x1, y2, color, x2, y2, color, x2, y1, color)
  end

  def draw_image_rect(x1, y1, x2, y2, image, z_index, color = WHITE)
    image.draw_as_quad(x1, y1, color, x2, y1, color, x2, y2, color, x1, y2, color, z_index)
  end

  private

  def load_fonts
    @font = Gosu::Font.new(self, FONT_LOCATION + "block_font.ttf", 50)
  end

  def load_images
    @background_image = Gosu::Image.new(self, BACKGROUND_LOCATION + "purple.png", true)
  end
end
