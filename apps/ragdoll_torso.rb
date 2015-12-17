require 'chipmunk'
class RagdollTorso
  BODY_WIDTH = 40
  BODY_HEIGHT = 70

  BODY_MASS = 10
  BODY_INERTIA = 100
  ZERO_VEC = CP::Vec2.new(0,0)
  attr_accessor :shape
  def initialize(window, pos = ZERO_VEC)
    @window = window

    @pos = pos
    # @left_arm = nil
    @body = CP::Body.new(BODY_MASS, BODY_INERTIA)
    @body.p = pos
    @body.v = ZERO_VEC
    @body.a = 0

    @shape_verts = [
      CP::Vec2.new(-BODY_WIDTH+pos.x, BODY_HEIGHT+pos.y),
      CP::Vec2.new(BODY_WIDTH+pos.x, BODY_HEIGHT+pos.y),
      CP::Vec2.new(BODY_WIDTH+pos.x, -BODY_HEIGHT+pos.y),
      CP::Vec2.new(-BODY_WIDTH+pos.x, -BODY_HEIGHT+pos.y)
    ]
    @shape = CP::Shape::Poly.new(@body, @shape_verts, ZERO_VEC)

    @shape.e = 0
    @shape.u = 1

    add_arms

    @window.space.add_body(@body)
    @window.space.add_shape(@shape)
  end

  def update
    # @body.a = 2
  end

  def add_arms
    group_id = 10
    @shape.group = group_id
    left_x, left_y = top_left
    left_arm_joint = CP::Vec2.new(left_x,left_y)
    left_arm_pos = left_arm_joint - CP::Vec2.new(RagdollArm::ARM_WIDTH/2.0,0)
    @left_arm = RagdollArm.new(@window, left_arm_pos)
    @left_arm.shape.group = group_id
    @left_arm_pivot = CP::Constraint::PivotJoint.new(@body, @left_arm.body, left_arm_joint)

    @window.space.add_constraint(@left_arm_pivot)
  end



  # def draw
  #   puts @left_arm_pivot.inspect
  #   x1, y1 = top_left
  #   x2, y2 = bottom_right
  #   @window.draw_rect(x1, y1, x2, y2)
  #   @left_arm.draw
  # end

  def draw
    @body.v = @body.v + CP::Vec2.new(1,0)
    Gosu::rotate(@body.a, @body.p.x,@body.p.y){
      x1, y1 = top_left
      x2, y2 = bottom_right
      @window.draw_rect(x1, y1, x2, y2)
        @left_arm.draw
    }
  end

  def top_left
    [@body.pos.x-BODY_WIDTH/2,@body.pos.y-BODY_HEIGHT/2]
  end

  def bottom_right
    [@body.pos.x+BODY_WIDTH/2,@body.pos.y+BODY_HEIGHT/2]
  end
end
