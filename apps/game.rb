require 'gosu'
require_relative 'lib/player'
require_relative 'lib/zorder'

module GameState
  MENU = 0
  GAME = 1
end

class Game < Gosu::Window
  GAME_NAME = 'Winky World Brawl'

  SELECTED_COLOR = 0xfff4cc00
  DEFAULT_COLOR = 0xffffffff
  WHITE = Gosu::Color.argb(0xff_ffffff)

  FONT_LOCATION = 'assets/fonts/'
  BACKGROUND_LOCATION = 'assets/backgrounds/'
  LOGO_LOCATION = 'assets/logos/'

  attr_reader :width, :height

  def initialize(width: 640, height: 480, fullscreen: false)
    super(width, height, fullscreen)
    self.caption = GAME_NAME

    @width = width
    @height = height
    @fullscreen = fullscreen
    @text_x = @width / 2
    @text_y = (2 * height) / 3
    @text_gap = 50

    load_fonts
    load_images

    @options = ["New Game", "Credits", "Quit"]
    @selected = 0

    test_controls = {:left => Gosu::KbLeft, :right => Gosu::KbRight, :up => Gosu::KbUp, :down => Gosu::KbDown }

    @player = Player.new(window: self, controls: test_controls)

    @counter = 0

    @game_state = GameState::MENU
  end

  def update
    if @game_state == GameState::GAME
      @counter += 1
      @player.update
    end
  end

  def draw
    if @game_state == GameState::GAME
      @font.draw(@counter, 0, 0, ZOrder::UI )
      draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
      @player.draw
    else
      draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
      @menu_logo.draw_rot(@width / 2, 120, ZOrder::UI, 0)

      @options.size.times do |i|
        color = option_selected(i) ? SELECTED_COLOR : DEFAULT_COLOR
        @font.draw_rel(@options[i], @text_x, @text_y + i * @text_gap, ZOrder::UI, 0.5, 0.5, 1, 1, color)
      end
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end

    if @game_state == GameState::MENU
      case id
      when Gosu::KbDown then next_option
      when Gosu::KbUp then previous_option
      when Gosu::KbReturn then select_option
      end
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
    @menu_image = Gosu::Image.new(self, BACKGROUND_LOCATION + "menu.png", true)
    @menu_logo = Gosu::Image.new(self, LOGO_LOCATION + "winky.jpeg", false)

    @background_image = Gosu::Image.new(self, BACKGROUND_LOCATION + "purple.png", true)
  end

  def option_selected(i)
    @selected == i
  end

  def next_option
    @selected = (@selected + 1) % @options.size
  end

  def previous_option
    @selected = (@selected - 1) % @options.size
  end

  def select_option
    case @options[@selected]
    when "New Game" then @game_state = GameState::GAME
    when "Credits" then puts "Credits"
    when "Quit" then close
    end
  end
end
