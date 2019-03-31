# Duck typing Boundary
class Boundary
  attr_reader :bounds
  def initialize(bounds)
    @bounds = bounds
  end

  def contains?(vec)
    bounds.contains?(vec)
  end

  def centroid
    bounds.centroid
  end
end
