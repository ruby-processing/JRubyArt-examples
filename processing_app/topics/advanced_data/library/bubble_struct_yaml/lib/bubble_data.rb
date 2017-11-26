MAX_BUBBLE = 10

# Bubble data holder
class BubbleData
  attr_reader :bubbles
  def initialize(bubbles)
    @bubbles = bubbles
  end

  def add_bubble(bubble)
    bubbles << bubble
    bubbles.shift if bubbles.size > MAX_BUBBLE
  end

  def to_struct
    bubbles.map(&:struct)
  end
end
