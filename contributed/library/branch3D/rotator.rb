# Rotator module is required because rotate is not implemented for
# JRubyArt 3D. Here we use Vec2D.rotate! to do Euclid rotation about an
# axis (we can then apply the rotation to each axis in turn)
# NB: we use quaternions in ArcBall (to avoid gimbal lock)
module Rotate
  def self.axis!(axis, vec, theta)
    array = vec.to_a
    array.slice! axis
    other = Vec2D.new(*array).rotate! theta
    case axis
    when 0 # xaxis
      vec.y = other.x
      vec.z = other.y
    when 1 # yaxis
      vec.x = other.x
      vec.z = other.y
    else # zaxis, by default
      vec.x = other.x
      vec.y = other.y
    end
    vec
  end
end
