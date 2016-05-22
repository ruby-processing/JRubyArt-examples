# encoding: UTF-8
# frozen_string_literal: true
require 'matrix'
require 'parallel'

# Mat4 class wraps ruby Matrix and multiply method
class Mat4
  attr_reader :mat

  def initialize(xaxis:, yaxis:, zaxis:, translate:)
    @mat = Matrix[
      [xaxis.x, yaxis.x, zaxis.x, translate.x],
      [xaxis.y, yaxis.y, zaxis.y, translate.y],
      [xaxis.z, yaxis.z, zaxis.z, translate.z],
      [0, 0, 0, 1]
    ]
  end

  # The processing version changes the input 'array', here we return
  # a new array with transformed values (which we then assign to the input)
  # see line 89 Frame_of_Reference.rb

  def *(other)
    Parallel.map(other) do |arr|
      matrix_to_vector(mat * Matrix[[arr.x], [arr.y], [arr.z], [1]])
    end
  end

  private

  # It isn't obvious but we only require first 3 elements
  def matrix_to_vector(vec)
    Vec3D.new(vec.column(0)[0], vec.column(0)[1], vec.column(0)[2])
  end
end
