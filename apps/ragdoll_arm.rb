require 'chipmunk'
class RagdollArm
  ARM_WIDTH = 40
  ARM_HEIGHT = 10
  attr_reader :body
  attr_accessor :shape
  ARM_MASS = 10
  ARM_INERTIA = 100
  ZERO_VEC = CP::Vec2.new(0,0)

  def initialize(window, position = ZERO_VEC)
    @window = window
    @color = Gosu::Color.argb(0xff_1fff56)
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
    @shape = CP::Shape::Poly.new(@body, @shape_verts, ZERO_VEC)

    @shape.e = 0
    @shape.u = 1

    @window.space.add_body(@body)
    @window.space.add_shape(@shape)
  end

  def update

  end

  def draw
    Gosu::rotate(@body.a, @body.p.x,@body.p.y){
      x1, y1 = top_left
      x2, y2 = bottom_right
      @window.draw_rect(x1, y1, x2, y2)
    }
    # puts "POSITION  :#{@body.p}     VELOCITY: #{@body.v}    ANGLE: #{@body.a} "
  end

  def top_left
    [@body.pos.x-ARM_WIDTH/2,@body.pos.y-ARM_HEIGHT/2]
  end

  def bottom_right
    [@body.pos.x+ARM_WIDTH/2,@body.pos.y+ARM_HEIGHT/2]
  end





end
