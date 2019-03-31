# For use with Boundary
class Rect
  attr_reader :lbt, :rtp
  def initialize(lbt, rtp)
    @lbt = lbt
    @rtp = rtp
  end

  def centroid
    (lbt + rtp) / 2
  end

  def contains?(vec)
    otherx = vec.x
    othery = vec.y
    return false if otherx < lbt.x || otherx > rtp.x
    return false if othery < lbt.y

    othery < rtp.y
  end
end
