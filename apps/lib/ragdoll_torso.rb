require 'chipmunk'

class RagdollTorso
  BODY_WIDTH = 40
  BODY_HEIGHT = 40
  WHITE = Gosu::Color.argb(0xff_ffffff)
  BODY_MASS = 50
  BODY_INERTIA = 100
  SPRITE_LOCATION  = 'assets/sprites/player.png'

  attr_accessor :shape, :body

  def self.load_image(window)
    @torso_image ||= Gosu::Image.new(window, SPRITE_LOCATION, false)
  end

  def initialize(window, pos = CP::Vec2::ZERO)
    @torso_image = self.class.load_image(window)
    @window = window
    @color = Gosu::Color.argb(0xff_1fff56)
    @pos = pos
    @body = CP::Body.new(BODY_MASS, BODY_INERTIA)
    @body.p = pos
    @body.v = CP::Vec2::ZERO
    @body.a = 0

    @shape_verts = [
      CP::Vec2.new(-BODY_WIDTH, BODY_HEIGHT),
      CP::Vec2.new(BODY_WIDTH, BODY_HEIGHT),
      CP::Vec2.new(BODY_WIDTH, -BODY_HEIGHT),
      CP::Vec2.new(-BODY_WIDTH, -BODY_HEIGHT)
    ]
    @shape = CP::Shape::Poly.new(@body, @shape_verts, CP::Vec2::ZERO)

    @shape.e = 0.9
    @shape.u = 1

    @window.space.add_body(@body)
    @window.space.add_shape(@shape)
  end

  def update
    dir = @body.v.normalize_safe
    angle_dir = CP::Vec2.for_angle(@body.a)
    mag = dir.cross(angle_dir)
    @body.a+= mag
  end

  def draw
    top_left, top_right, bottom_left, bottom_right = self.rotate
    @torso_image.draw_as_quad(top_left.x, top_left.y, @color,
                      top_right.x, top_right.y, @color,
                      bottom_left.x, bottom_left.y, @color,
                      bottom_right.x, bottom_right.y, @color,
                      1)
  end

  def rotate
    half_diagonal = Math.sqrt(2) * (BODY_WIDTH)
    [-45, +45, -135, +135].collect do |angle|
       CP::Vec2.new(@body.p.x + Gosu::offset_x(@body.a.radians_to_gosu + angle,
                                               half_diagonal),

                    @body.p.y + Gosu::offset_y(@body.a.radians_to_gosu + angle,
                                               half_diagonal))
    end
  end
end
