load_library :slider

java_import 'monkstone.slider.SliderGroup'

attr_reader :sliders, :r, :gs, :b

def setup
  sketch_title 'Slider Group'
  @sliders = SliderGroup.new(self)
  @r, @gs, @b = 20, 20, 20
  sliders.vertical
  sliders.add_slider(0.0, 255.0, 50.0)
  sliders.add_slider(0.0, 255.0, 100.0)
  sliders.add_slider(0.0, 255.0, 100.0)
end

def draw
  background(b, r, gs)
  fill(r, gs, b)
  ellipse(300, 200, 300, 300)
  @r = sliders.read_value(2)
  @gs = sliders.read_value(1)
  @b = sliders.read_value(0)
end

def settings
  size(600, 400)
  smooth 4
end
