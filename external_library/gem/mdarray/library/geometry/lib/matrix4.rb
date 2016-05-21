# uber simple Homogeneous 4 x 4 matrix
require 'mdarray'

class Mat4
  attr_reader :mat

  def initialize(xaxis:, yaxis:, zaxis:, translate:)
    @mat = MDMatrix.double([4, 4], [
    xaxis.x, yaxis.x, zaxis.x, translate.x,
    xaxis.y, yaxis.y, zaxis.y, translate.y,
    xaxis.z, yaxis.z, zaxis.z, translate.z,
    0, 0, 0, 1]
    )
  end

  # The processing version changes the input 'array', here we return
  # a new array with transformed values (which we then assign to the input)
  # see line 89 Frame_of_Reference.rb, NB: regular ruby Matrix is much faster

  def *(other)
    other.map.each do |arr|
      matrix_to_vector(mat * MDMatrix.double([4, 1], [arr.x, arr.y, arr.z, 1]))
    end
  end

  private

  # It isn't obvious but we only require first 3 elements
  def matrix_to_vector(vec)
    Vec3D.new(vec[0, 0], vec[1, 0], vec[2, 0])
  end
end
