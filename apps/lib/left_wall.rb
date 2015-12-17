class LeftWall
  PADDING = 1
  INFINITY = 1.0/0

  attr_reader :a, :b

  def initialize(width, height, window)
    @width = width
    @height = height
    @window = window
    @color = 000000

    @a = CP::Vec2.new(0,0)
    @b = CP::Vec2.new(@width - (PADDING * 2), 0)

    # CHIPMUNK BODY
    @body = CP::Body.new(INFINITY, INFINITY)
    @body.p = CP::Vec2.new(PADDING, @width - PADDING)
    @body.v = CP::Vec2.new(0, 0)

    # CHIPMUNK SHAPE
    @shape = CP::Shape::Segment.new(@body, @a, @b, 1)
    @shape.e = 0
    @shape.u = 1

    # STATIC SO THAT THE GRAVITY OF THE SPACE DOESN'T HAVE ITS WAY
    @window.space.add_static_shape(@shape)
  end

  def draw
    @window.draw_line(@body.p.x + a.x, @body.p.y + a.y, @color,
                      @body.p.x + b.x, @body.p.y + b.y, @color,
                      1)
  end
end
