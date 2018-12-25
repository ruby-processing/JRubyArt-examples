# Rotator module is required because rotate is not implemented for JRubyArt
# Vec3D (below implementation based on Euler angles)
# NB: we use quaternions in ArcBall (avoiding possible gimbal lock)
module Rotate
  def self.rotate_x!(vec, theta)
    co = Math.cos(theta)
    si = Math.sin(theta)
    zz = co * vec.z - si * vec.y
    vec.y = si * vec.z + co * vec.y
    vec.z = zz
    vec
  end

  def self.rotate_y!(vec, theta)
    co = Math.cos(theta)
    si = Math.sin(theta)
    xx = co * vec.x - si * vec.z
    vec.z = si * vec.x + co * vec.z
    vec.x = xx
    vec
  end

  def self.rotate_z!(vec, theta)
    co = Math.cos(theta)
    si = Math.sin(theta)
    xx = co * vec.x - si * vec.y
    vec.y = si * vec.x + co * vec.y
    vec.x = xx
    vec
  end
end
