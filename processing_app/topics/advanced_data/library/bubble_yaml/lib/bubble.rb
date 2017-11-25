# The Bubble class
class Bubble
  include Processing::Proxy
  attr_reader :pos, :diameter, :name, :over

  def initialize(pos, diameter, name)
    @pos, @diameter, @name = pos, diameter, name
    @over = false
  end

  def rollover(px, py)
    distance = dist px, py, pos[X], pos[Y]
    @over = (distance < diameter / 2.0)
  end

  def display
    xpos = pos[X]
    ypos = pos[Y]
    display_bubble(xpos, ypos)
    return unless over
    display_label(xpos, ypos)
  end

  def display_bubble(xpos, ypos)
    stroke 0
    stroke_weight 2
    no_fill
    ellipse xpos, ypos, diameter, diameter
  end

  def display_label(xpos, ypos)
    fill 0
    text_align CENTER
    text(name, xpos, ypos + diameter / 2.0 + 20)
  end

  def to_h
    {
      'position' => pos,
      'diameter' => diameter,
      'label' => name
    }
  end
end
