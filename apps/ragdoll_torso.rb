class RagdollTorso
  BODY_WIDTH = 10
  BODY_HEIGHT = 17

  BODY_MASS = 10
  BODY_INERTIA = 100
  ZERO_VEC = CP::Vec2.new(0,0)

  def initialize(window, position = ZERO_VEC)
    @window = window

    @position = position

    @body = CP::Body.new(BODY_MASS, BODY_INERTIA)
    @body.p = position
    @body.v = ZERO_VEC
    @body.a = 0

    @shape_verts = [
      CP::Vec2.new(-BODY_WIDTH, BODY_HEIGHT),
      CP::Vec2.new(BODY_WIDTH, BODY_HEIGHT),
      CP::Vec2.new(BODY_WIDTH, -BODY_HEIGHT),
      CP::Vec2.new(-BODY_WIDTH, -BODY_HEIGHT)
    ]
    @shape = CP::Shape::Poly.new(@body, shape_verts, ZERO_VEC)

    @shape.e = 0
    @shape.u = 1

    @window.space.add_body(@body)
    @window.spade.add_shape(@shape)
  end

  def update
  end

  def add_arms
    left_x, left_y = top_left
    left_arm_pos = CP::Vec2.new(left_x,left_y)
    left_arm = RagdollArm.new(@window, left_arm_pos)
    left_arm_pivot = CP::Constraint::PivotJoint.new(@body, left_arm.body, left_arm_pos, left_arm_pos)
    @window.space.add_constraint(left_arm_pivot)
  end



  def draw
    x1, y1 = top_left
    x2, y2 = bottom_right
    @window.draw_rect(x1, y1, x2, y2)
  end

  def top_left
    [@shape_verts[3].x,@shape_verts[3].y]
  end

  def bottom_right
    [@shape_verts[1].x,@shape_verts[1].y]
  end
end
