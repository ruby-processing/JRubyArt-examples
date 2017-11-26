load_library :bubble_yaml

attr_reader :bubbles, :bubble_data

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
  text('Click to add bubbles.', 10, height - 10)
end

def load_data
  data = BubbleReader.new.read(data_path('data.yml')).fetch('emotions')
  @bubbles = data.map do |point|
    Bubble.new(point['position'], point['diameter'], point['label'])
  end
  @bubble_data = BubbleData.new(bubbles)
end

def save_data
  # demonstrate how easy it is to create yaml object from a hash in ruby
  # you could easily store 'colors as well as 'emotions' bubbles
  writer = BubbleWriter.new(type: 'emotions', data: bubble_data.to_h)
  # overwite existing 'data.yml'
  writer.write(data_path('data.yml'))
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data.add_bubble(
    Bubble.new([mouse_x, mouse_y], rand(40..80), 'new label')
  )
  save_data
  # reload the yaml data from the freshly created file
  load_data
end
