# encapsulate Bird behaviour
class Bird
  include Processing::Proxy
  attr_accessor :offset_x, :offset_y, :offset_z
  attr_accessor :w, :h
  attr_accessor :body_fill, :wing_fill
  attr_accessor :ang, :ang2, :ang3, :ang4
  attr_accessor :radius_x, :radius_y, :radius_z
  attr_accessor :rot_x, :rot_y, :rot_z
  attr_accessor :flap_speed
  attr_accessor :rot_speed

  def initialize(offset_x, offset_y, offset_z, w, h)
    defaults
    @offset_x, @offset_y, @offset_z = offset_x, offset_y, offset_z
    @w, @h = w, h
  end

  def defaults
    @ang, @ang2, @ang3, @ang4 = 0.0, 0.0, 0.0, 0.0
    @body_fill, @wing_fill = 153, 204
    @flap_speed = 0.4
    @rot_speed = 0.1
    @radius_x, @radius_y, @radius_z = 120.0, 200.0, 700.0
  end

  def flight(radius_x, radius_y, radius_z, rot_x, rot_y, rot_z)
    @radius_x, @radius_y, @radius_z = radius_x, radius_y, radius_z
    @rot_x, @rot_y, @rot_z = rot_x, rot_y, rot_z
    self  # return self means we can chain methods
  end

  def wing_speed(flap_speed)
    @flap_speed = flap_speed
    self  # return self means we can chain methods
  end

  def rotation_speed(rot_speed)
    @rot_speed = rot_speed
    self  # return self means we can chain methods
  end

  def fly
    push_matrix
    px = DegLut.sin(@ang3) * @radius_x
    py = DegLut.cos(@ang3) * @radius_y
    pz = DegLut.sin(@ang4) * @radius_z
    translate @offset_x + px,
                  @offset_y + py,
                  @offset_z + pz
    rotate_x DegLut.sin(@ang2) * @rot_x
    rotate_y DegLut.sin(@ang2) * @rot_y
    rotate_z DegLut.sin(@ang2) * @rot_z
    fill @body_fill
    box @w / 5, @h, @w / 5
    fill @wing_fill
    push_matrix
    rotate_y DegLut.sin(@ang) * 20
    rect(0, -@h / 2, @w, @h)
    pop_matrix
    push_matrix
    rotate_y DegLut.sin(@ang) * -20
    rect(-@w, -@h / 2, @w, @h)
    pop_matrix
    @ang += @flap_speed
    @flap_speed *= -1 if @ang > Math::PI || @ang < -Math::PI
    @ang2 += @rot_speed
    @ang3 += 1.25
    @ang4 += 0.55
    pop_matrix
  end
end
