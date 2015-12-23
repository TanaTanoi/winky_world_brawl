class Boundary
  PADDING = 1
  INFINITY = 1.0/0
  BOUNDARY_COLOR = Gosu::Color.argb(0xff_ffff00)

  attr_reader :a, :b

  def initialize(x1, y1, x2, y2, space)
    @a = CP::Vec2.new(x1,y1)
    @b = CP::Vec2.new(x2, y2)

    # CHIPMUNK BODY
    @body = CP::Body.new(INFINITY, INFINITY)

    # CHIPMUNK SHAPE
    shape = CP::Shape::Segment.new(@body, @a, @b, 1)
    shape.e = 0.2
    shape.u = 1

    # STATIC SO THAT THE GRAVITY OF THE SPACE DOESN'T HAVE ITS WAY
    space.add_static_shape(shape)
  end

  def draw(window)
    window.draw_line(@a.x, @a.y, BOUNDARY_COLOR,
                     @b.x, @b.y, BOUNDARY_COLOR,
                     5)
  end
end
