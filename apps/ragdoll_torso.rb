require 'chipmunk'
class RagdollTorso
  BODY_WIDTH = 40
  BODY_HEIGHT = 70
  WHITE = Gosu::Color.argb(0xff_1fff56)
  BODY_MASS = 50
  BODY_INERTIA = 100
  ZERO_VEC = CP::Vec2.new(0,0)
  attr_accessor :shape, :body
  def initialize(window, pos = ZERO_VEC)
    @window = window

    @pos = pos
    @body = CP::Body.new(BODY_MASS, BODY_INERTIA)
    @body.p = pos
    @body.v = ZERO_VEC
    @body.a = 0

    # @shape_verts = [
    #   CP::Vec2.new(-BODY_WIDTH+pos.x, BODY_HEIGHT+pos.y),
    #   CP::Vec2.new(BODY_WIDTH+pos.x, BODY_HEIGHT+pos.y),
    #   CP::Vec2.new(BODY_WIDTH+pos.x, -BODY_HEIGHT+pos.y),
    #   CP::Vec2.new(-BODY_WIDTH+pos.x, -BODY_HEIGHT+pos.y)
    # ]
    @shape_verts = [
      CP::Vec2.new(-BODY_WIDTH, BODY_HEIGHT),
      CP::Vec2.new(BODY_WIDTH, BODY_HEIGHT),
      CP::Vec2.new(BODY_WIDTH, -BODY_HEIGHT),
      CP::Vec2.new(-BODY_WIDTH, -BODY_HEIGHT)
    ]
    @shape = CP::Shape::Poly.new(@body, @shape_verts, CP::Vec2::ZERO)

    @shape.e = 0
    @shape.u = 1

    add_arms

    @window.space.add_body(@body)
    @window.space.add_shape(@shape)
  end

  def update
  end

  def add_arms
    group_id = rand(1..200)
    @shape.group = group_id
    left_x, left_y = top_left
    left_arm_joint = CP::Vec2.new(left_x,left_y)
    left_arm_pos = left_arm_joint - CP::Vec2.new(RagdollArm::ARM_WIDTH/2.0,0)
    @left_arm = RagdollArm.new(@window, left_arm_pos)
    @left_arm.shape.group = group_id

    @left_arm_pivot = CP::Constraint::PivotJoint.new(@body, @left_arm.body,left_arm_joint)

    @window.space.add_constraint(@left_arm_pivot)

    right_x, right_y = top_right
    right_arm_joint = CP::Vec2.new(right_x,right_y)
    right_arm_pos = right_arm_joint + CP::Vec2.new(RagdollArm::ARM_WIDTH/2.0,0)
    @right_arm = RagdollArm.new(@window, right_arm_pos)
    @right_arm.shape.group = group_id

    @right_arm_pivot = CP::Constraint::PivotJoint.new(@body, @right_arm.body,right_arm_joint)

    @window.space.add_constraint(@right_arm_pivot)
  end

  # def draw
  #   puts @left_arm_pivot.inspect
  #   x1, y1 = top_left
  #   x2, y2 = bottom_right
  #   @window.draw_rect(x1, y1, x2, y2)
  #   @left_arm.draw
  # end

  def draw
    # @body.v = @body.v + CP::Vec2.new(1,0)
    Gosu::rotate(@body.a, @body.p.x,@body.p.y){
      x1, y1 = top_left
      x2, y2 = bottom_right
      @window.draw_rect(x1, y1, x2, y2)
    }
    @left_arm.draw
    @right_arm.draw
    Gosu::draw_line(@left_arm.body.p.x, @left_arm.body.p.y, WHITE, @body.p.x,@body.p.y, WHITE)
  end

  def top_left
    [@body.pos.x-BODY_WIDTH/2,@body.pos.y-BODY_HEIGHT/2]
    # [@body.pos.x,@body.pos.y]
  end
  def top_right
    [@body.pos.x+BODY_WIDTH/2,@body.pos.y-BODY_HEIGHT/2]
  end

  def bottom_right
    [@body.pos.x+BODY_WIDTH/2,@body.pos.y+BODY_HEIGHT/2]
    # [@body.pos.x+BODY_WIDTH,@body.pos.y+BODY_HEIGHT]
  end
end
