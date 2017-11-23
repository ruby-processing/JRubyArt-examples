require 'yaml'

attr_reader :bubbles, :bubble_data

 MAX_BUBBLE = 10

def settings
  size(640, 360)
end

def setup
  sketch_title 'Bubble Yaml'
  # read source_string from file
  load_data
end

def draw
  background 255
  bubbles.each do |bubble|
    bubble.display
    bubble.rollover(mouse_x, mouse_y)
  end
end

def load_data
  yaml = YAML.load_file(data_path('data.yml'))
  # parse the source string
  @bubble_data = BubbleData.new 'bubbles'
  # get the bubble_data from the top level hash
  data = bubble_data.extract_data yaml
  # map the bubble_data array to an array of bubbles
  @bubbles = data.map do |point|
    pos = point['position']
    Bubble.new(pos['x'], pos['y'], point['diameter'], point['label'])
  end
end

def save_data
  # demonstrate how easy it is to create json object from a hash in ruby
  hash = bubble_data.to_hash
  # overwite existing 'data.yml'
  open(data_path('data.yml'), 'w') { |file| file.write(hash.to_yaml) }
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data.add_bubble(
    Bubble.new(mouse_x, mouse_y, rand(40..80), 'new label')
  )
  save_data
  # reload the yaml data from the freshly created file
  load_data
end

# Bubble data holder
class BubbleData
  attr_reader :name, :data
  def initialize(name = 'bubbles')
    @name = name
    @bubbles = []
  end

  def add_bubble(bubble)
    bubbles << bubble
    bubbles.shift if bubbles.size > MAX_BUBBLE
  end

  def extract_data(yaml)
    @bubbles = yaml[name]
  end

  def to_hash
    { name => bubbles.map(&:to_hash) }
  end
end

# The Bubble class
class Bubble
  attr_reader :x, :y, :diameter, :name, :over

  def initialize(x, y, diameter, name)
    @x, @y, @diameter, @name = x, y, diameter, name
    @over = false
  end

  def rollover(px, py)
    distance = dist px, py, x, y
    @over = (distance < diameter / 2.0)
  end

  def display
    stroke 0
    stroke_weight 2
    no_fill
    ellipse x, y, diameter, diameter
    return unless over
    fill 0
    text_align CENTER
    text(name, x, y + diameter / 2.0 + 20)
  end

  def to_hash
    {
      'position' => { 'x' => x, 'y' => y },
      'diameter' => diameter,
      'label' => name
    }
  end
end
