class Ragdoll
  MOVE_AMOUNT = 5
  BODY_SIZE = 40
  WHITE = Gosu::Color.argb(0xff_ffffff)
  BODY_MASS = 50
  BODY_INERTIA = 100
  SPRITE_LOCATION  = 'assets/sprites/player.png'

  attr_accessor :shape, :body

  def self.load_image(window)
    @image ||= Gosu::Image.new(window, SPRITE_LOCATION, false)
  end

  def initialize(window, pos, image = self.class.load_image(window))
    @image = image
    @window = window
    @body = CP::Body.new(BODY_MASS, BODY_INERTIA)
    @body.p = pos
    @body.v = CP::Vec2::ZERO
    @body.a = 0

    @shape_verts = [
      CP::Vec2.new(-BODY_SIZE, BODY_SIZE),
      CP::Vec2.new(BODY_SIZE, BODY_SIZE),
      CP::Vec2.new(BODY_SIZE, -BODY_SIZE),
      CP::Vec2.new(-BODY_SIZE, -BODY_SIZE)
    ]
    @shape = CP::Shape::Poly.new(@body, @shape_verts, CP::Vec2::ZERO)

    @shape.e = 0.2
    @shape.u = 1

    @window.space.add_body(@body)
    @window.space.add_shape(@shape)
  end

  def update
    dir = @body.v.normalize_safe
    angle_dir = CP::Vec2.for_angle(@body.a)
    mag = dir.cross(angle_dir)
    @body.a+= mag
    @body.w = 0
  end

  def draw
    top_left, top_right, bottom_left, bottom_right = rotate

    # Gotta draw things back to front because we're in space so that makes sense right?
    @image.draw_as_quad(bottom_left.x, bottom_left.y, WHITE, bottom_right.x, bottom_right.y, WHITE,
                              top_left.x, top_left.y, WHITE, top_right.x, top_right.y, WHITE, 1)
  end

  def rotate
    half_diagonal = Math.sqrt(2) * (BODY_SIZE)
    [-45, +45, -135, +135].collect do |angle|
       CP::Vec2.new(@body.p.x + Gosu::offset_x(@body.a.radians_to_gosu + angle,
                                               half_diagonal),

                    @body.p.y + Gosu::offset_y(@body.a.radians_to_gosu + angle,
                                               half_diagonal))
    end
  end

  def move_up
    move_by vec2(0,-MOVE_AMOUNT)
  end

  def move_down
    move_by vec2(0, MOVE_AMOUNT)
  end

  def move_left
    move_by vec2(-MOVE_AMOUNT, 0)
  end

  def move_right
    move_by vec2(MOVE_AMOUNT, 0)
  end

  def move_by(vector = vec2(0,0))
    @body.v += vector
  end
end
