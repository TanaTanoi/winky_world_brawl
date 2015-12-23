require 'gosu'
require_relative 'lib/player'
require_relative 'lib/zorder'
require_relative 'lib/game_state'
require_relative 'lib/player_controls'
require_relative 'lib/boundary'
require_relative 'lib/king_hill'
require_relative 'lib/effect'

class Game < Gosu::Window
  GAME_NAME = 'Winky World Brawl'
  MENU_OPTIONS = ["New Game", "Credits", "Quit"]

  SELECTED_COLOR = 0xfff4cc00
  DEFAULT_COLOR = 0xffffffff
  GREEN = Gosu::Color.argb(0xff_1fff56)
  WHITE = Gosu::Color.argb(0xff_ffffff)
  SCREEN_WIDTH = 1280
  SCREEN_HEIGHT = 720

  WINNING_SCORE = 15000

  POWERUP_SPAWN_FREQUENCY = 4

  FONT_LOCATION = 'assets/fonts/'
  BACKGROUND_LOCATION = 'assets/backgrounds/'
  LOGO_LOCATION = 'assets/logos/'
  AUDIO_LOCATION = 'assets/audio/'

  attr_reader :width, :height
  attr_accessor :space

  def initialize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT, fullscreen: true)
    super(width, height, fullscreen)
    self.caption = GAME_NAME
    @time = Time.now
    @width = width
    @height = height
    @fullscreen = fullscreen
    @text_x = @width / 2
    @text_y = (2 * height) / 3
    @text_gap = 25
    @space = CP::Space.new

    @powerups = []
    @effects = []
    @bounderies = [
      Boundary.new(0, 0, @width, 0, space),
      Boundary.new(0, 0, 0, @height, space),
      Boundary.new(0, @height, @width, @height, space),
      Boundary.new(@width, 0, @width, @height, space)
    ]

    load_fonts
    load_images
    initialize_players

    @hill = KingHill.new(self)

    @selected = 0

    @game_state = GameState::MENU

    @music = Gosu::Song.new(AUDIO_LOCATION + "music.wav").play
  end

  def update
    if @game_state == GameState::GAME
      check_for_winner
    end

    if @game_state == GameState::GAME || @game_state == GameState::GAME_OVER
      @hill.update

      @effects.each(&:update)
      cleanup_effects

      if @game_state == GameState::GAME

        @players.each do |player|
          player.update
          respawn_player(player) if out_of_bounds?(player)
          player.add_score(10) if player_on_hill?(player)
        end
        check_powerup_collision
        create_powerup if powerup_time_elapsed?
      end

      @space.step((1.0/60.0))
    end
  end

  def powerup_time_elapsed?
    if (Time.now - @time) > POWERUP_SPAWN_FREQUENCY
      @time = Time.now
      true
    end
  end

  def draw
    draw_bounds

    if @game_state == GameState::GAME
      draw_game
    elsif @game_state == GameState::GAME_OVER
      draw_game
      draw_game_over
    else
      draw_menu
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

  def generate_effect(type, pos)
    @effects << Effect.new(type: type, pos: pos, window: self)
  end

  private

  def initialize_players
    @players = [
      Player.new(window: self, controls: PlayerControls::PLAYER1, pos: vec2(width/3, height/2), id: 1),
      Player.new(window: self, controls: PlayerControls::PLAYER2, pos: vec2(width/2, height/2), id: 2),
      Player.new(window: self, controls: PlayerControls::PLAYER3, pos: vec2(width/2, height/3), id: 3),
      Player.new(window: self, controls: PlayerControls::PLAYER4, pos: vec2(width/3, height/3), id: 4)
    ]
  end

  def default_position(player)
    if player == @players[0]
      vec2(width/3, height/2)
    elsif player == @players[1]
      vec2(width/2, height/2)
    elsif player == @players[2]
      vec2(width/2, height/3)
    elsif player == @players[3]
      vec2(width/3, height/3)
    end
  end

  def load_fonts
    @font = Gosu::Font.new(self, FONT_LOCATION + "block_font.ttf", 25)
    @menu_font = Gosu::Font.new(self, FONT_LOCATION + "block_font.ttf", 50)
    @winning_font = Gosu::Font.new(self, FONT_LOCATION + "block_font.ttf", 80)
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

  def create_powerup(pos: random_position, type: Powerup::POWERUPS.sample)
    @powerups.push Powerup.new(self, pos, power: type)
  end

  def random_position
    vec2(rand(0..@width),rand(0..@height))
  end

  def check_powerup_collision
    @players.each do |player|
      @powerups.map! do |pu|
        if pu.touching?(player)
          pu.activate(player)
          nil
        else
          pu
        end
      end.compact!
    end
  end

  def draw_bounds
    @bounderies.each do |b|
      b.draw(self)
    end
  end

  def draw_game
    draw_scoreboard
    draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
    @hill.draw
    @powerups.each(&:draw)
    @players.each do |player|
      draw_laser(player.ragdoll.body.p, @hill.p) if player_on_hill?(player)
      player.draw
    end

    @effects.each(&:draw)

    @font.draw("Esc to quit", 20, @height - 40, ZOrder::UI)
  end

  def draw_game_over
    @winning_font.draw("Player#{@winning_player.id} has won!", (@width / 4), 100, ZOrder::UI)
  end

  def draw_laser(vec_a, vec_b, color_a = GREEN, color_b = GREEN)
    Gosu::draw_line(vec_a.x, vec_a.y, color_a, vec_b.x, vec_b.y, color_b, ZOrder::Player)
  end

  def check_for_winner
    if @players.any? { |p| p.score >= WINNING_SCORE }
      @winning_player = @players.detect { |p| p.score >= WINNING_SCORE }
      @game_state = GameState::GAME_OVER
      @music = Gosu::Song.new(AUDIO_LOCATION + "over.ogg").play
    end
  end

  def player_on_hill?(player)
    player.ragdoll.body.p.near?(@hill.p, 100)
  end

  def draw_scoreboard
    x_offset = 20
    y_offset = @text_gap
    @font.draw("Scoreboard", x_offset, 5, ZOrder::UI)
    @players.size.times do |i|
      @font.draw("Player#{i + 1}: #{@players[i].score}", x_offset, y_offset + i * @text_gap, ZOrder::UI)
    end
  end

  def draw_menu
    draw_image_rect(0, 0, @width, @height, @background_image, ZOrder::Background)
    @menu_logo.draw_rot(@width / 2, 200, ZOrder::UI, 0)

    MENU_OPTIONS.size.times do |i|
      color = option_selected(i) ? SELECTED_COLOR : DEFAULT_COLOR
      @menu_font.draw_rel(MENU_OPTIONS[i], @text_x, @text_y + i * @text_gap * 2, ZOrder::UI, 0.5, 0.5, 1, 1, color)
    end
  end

  def out_of_bounds?(player)
    player_position = player.ragdoll.body.p.to_a
    player_x = player_position[0]
    player_y = player_position[1]

    player_x < 0 || player_x > @width || player_y < 0 || player_y > @height
  end

  def respawn_player(player)
    player.ragdoll.body.p = default_position(player)
    player.ragdoll.body.v = CP::Vec2::ZERO
    player.ragdoll.body.a = 0
    player.disable(200)
  end

  def cleanup_effects
    @effects.reject { |e| e.decay <= 0 }
  end
end
