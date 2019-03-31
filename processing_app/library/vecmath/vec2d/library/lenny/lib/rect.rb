# For use with Boundary
class Rect
  attr_reader :vec1, :vec2
  def initialize(vec1, vec2)
    @vec1 = vec1
    @vec2 = vec2
  end

  def centroid
    (vec1 + vec2) / 2
  end

  def contains?(vec)
    xminmax = [vec1.x, vec2.x].minmax
    yminmax = [vec1.y, vec2.y].minmax
    return false if vec.x < xminmax[0]
    return false if vec.x > xminmax[1]
    return false if vec.y < yminmax[0]

    vec.y < yminmax[1]
  end
end
