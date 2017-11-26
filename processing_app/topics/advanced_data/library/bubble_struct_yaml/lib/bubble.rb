# The Bubble class
class Bubble
  include Processing::Proxy
  attr_reader :struct, :over

  def initialize(struct)
    @struct = struct
    @over = false
  end

  def rollover(px, py)
    distance = dist px, py, struct.xpos, struct.ypos
    @over = (distance < struct.diameter / 2.0)
  end

  def display
    display_bubble(struct.xpos, struct.ypos)
    return unless over
    display_label(struct.xpos, struct.ypos)
  end

  def display_bubble(xpos, ypos)
    stroke 0
    stroke_weight 2
    no_fill
    ellipse xpos, ypos, struct.diameter, struct.diameter
  end

  def display_label(xpos, ypos)
    fill 0
    text_align CENTER
    text(struct.label, xpos, ypos + struct.diameter / 2.0 + 20)
  end
end
