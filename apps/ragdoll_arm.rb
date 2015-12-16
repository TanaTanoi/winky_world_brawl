class RagdollArm
  ARM_WIDTH = 8
  ARM_HEIGHT = 5
  attr_reader :body
  ARM_MASS = 10
  ARM_INERTIA = 100

  def initialize(window, position = ZERO_VEC)
    @window = window
    @color = Gosu::Color.argb(0xff_ffffff)
    @body = CP::Body.new(ARM_MASS, ARM_INERTIA)
    @body.p = position
    @body.v = ZERO_VEC
    @body.a = 0

    @shape_verts = [
      CP::Vec2.new(-ARM_WIDTH, ARM_HEIGHT),
      CP::Vec2.new(ARM_WIDTH, ARM_HEIGHT),
      CP::Vec2.new(ARM_WIDTH, -ARM_HEIGHT),
      CP::Vec2.new(-ARM_WIDTH, -ARM_HEIGHT)
    ]
    @shape = CP::Shape::Poly.new(@body, shape_verts, ZERO_VEC)

    @shape.e = 0
    @shape.u = 1

    @window.space.add_body(@body)
    @window.spade.add_shape(@shape)
  end

  def draw
    top_left, top_right, bottom_left, bottom_right = self.rotate
    @window.draw_quad(top_left.x, top_left.y, @color,
                      top_right.x, top_right.y, @color,
                      bottom_left.x, bottom_left.y, @color,
                      bottom_right.x, bottom_right.y, @color,
                      1)
  end

  def rotate

    half_diagonal = Math.sqrt(2) * (ARM_WIDTH)
    [-45, +45, -135, +135].collect do |angle|
       CP::Vec2.new(@body.p.x + Gosu::offset_x(@body.a.radians_to_gosu + angle,
                                               half_diagonal),

                    @body.p.y + Gosu::offset_y(@body.a.radians_to_gosu + angle,
                                               half_diagonal))

    end
  end
end
