require 'gosu'
require_relative 'lib/player'
require_relative 'lib/zorder'
require_relative 'lib/game_state'
require_relative 'lib/player_controls'
require_relative 'lib/horizontal_boundary'
require_relative 'lib/vertical_boundary'
require_relative 'lib/king_hill'

class Game < Gosu::Window
  GAME_NAME = 'Winky World Brawl'
  MENU_OPTIONS = ["New Game", "Credits", "Quit"]

  SELECTED_COLOR = 0xfff4cc00
  DEFAULT_COLOR = 0xffffffff
  GREEN = Gosu::Color.argb(0xff_1fff56)
  WHITE = Gosu::Color.argb(0xff_ffffff)
  SCREEN_WIDTH = 1280
  SCREEN_HEIGHT = 720

  FONT_LOCATION = 'assets/fonts/'
  BACKGROUND_LOCATION = 'assets/backgrounds/'
  LOGO_LOCATION = 'assets/logos/'

  attr_reader :width, :height
  attr_accessor :space

  def initialize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT, fullscreen: true)
    super(width, height, fullscreen)
    self.caption = GAME_NAME

    @width = width
    @height = height
    @fullscreen = fullscreen
    @text_x = @width / 2
    @text_y = (2 * height) / 3
    @text_gap = 50
    @space = CP::Space.new

    @floor = HorizontalBoundary.new(SCREEN_WIDTH, SCREEN_HEIGHT, self)
    @ceiling = HorizontalBoundary.new(SCREEN_WIDTH, 1, self)
    @left_wall = VerticalBoundary.new(1, SCREEN_HEIGHT, self)
    @right_wall = VerticalBoundary.new(SCREEN_WIDTH, SCREEN_HEIGHT, self)

    load_fonts
    load_images
    initialize_players

    @hill = KingHill.new(self)

    @selected = 0

    # @space.gravity = CP::Vec2.new(0,10)

    @counter = 0

    @game_state = GameState::MENU
  end

  def update
    if @game_state == GameState::GAME
      @hill.update
      @players.each do |player|
        player.update
        respawn_player(player) if out_of_bounds?(player)
      end
      @space.step((1.0/60.0))
    end
  end

  def draw_laser(vec_a, vec_b, color_a = GREEN, color_b = GREEN)
    Gosu::draw_line(vec_a.x, vec_a.y, color_a, vec_b.x, vec_b.y, color_b, ZOrder::Player)
  end

  def draw
    @floor.draw
    @ceiling.draw
    @left_wall.draw
    @right_wall.draw

    if @game_state == GameState::GAME
      @font.draw("ESC to Quit", @text_x - @width / 8, 0, ZOrder::UI)
      draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
      @hill.draw
      @players.each do |player|
        draw_laser(player.ragdoll.body.p, @hill.p)
        player.draw
      end
    else
      draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
      @menu_logo.draw_rot(@width / 2, 120, ZOrder::UI, 0)

      MENU_OPTIONS.size.times do |i|
        color = option_selected(i) ? SELECTED_COLOR : DEFAULT_COLOR
        @font.draw_rel(MENU_OPTIONS[i], @text_x, @text_y + i * @text_gap, ZOrder::UI, 0.5, 0.5, 1, 1, color)
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

  def draw_image_rect(x1, y1, x2, y2, image, z_index, color = WHITE)
    image.draw_as_quad(x1, y1, color, x2, y1, color, x2, y2, color, x1, y2, color, z_index)
  end

  private

  def initialize_players
    @players = [
      Player.new(window: self, controls: PlayerControls::PLAYER1, pos: vec2(width/3, height/2)),
      Player.new(window: self, controls: PlayerControls::PLAYER2, pos: vec2(width/2, height/2))
    ]
  end

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
    @selected = (@selected + 1) % MENU_OPTIONS.size
  end

  def previous_option
    @selected = (@selected - 1) % MENU_OPTIONS.size
  end

  def select_option
    case MENU_OPTIONS[@selected]
    when "New Game" then @game_state = GameState::GAME
    when "Credits" then puts "Credits"
    when "Quit" then close
    end
  end

  def out_of_bounds?(player)
    player_position = player.ragdoll.body.p.to_a
    player_x = player_position[0]
    player_y = player_position[1]

    player_x < 0 || player_x > @width || player_y < 0 || player_y > @height
  end

  def respawn_player(player)
    player.ragdoll.body.p = vec2(@width/2, @height/2)
    player.ragdoll.body.v = CP::Vec2::ZERO
    player.ragdoll.body.a = 0
    player.disable(200)
  end
end
