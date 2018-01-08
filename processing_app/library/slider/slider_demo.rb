load_library :slider
attr_reader :sliders, :r, :gs, :b, :back

def settings
  size(600, 400)
  smooth(4)
end

def setup
  sketch_title 'Slider Demo'
  @back = true
  @r, @gs, @b = 0, 0, 0
  create_gui
end

def draw
  background(r + 125, gs, b)
  @r = sliders[0].read_value
  @gs = sliders[1].read_value
  @b = sliders[2].read_value
end

def create_gui
  @sliders = (1..3).map do |i|
    Slider.slider(
    app: self,
    vertical: true,
    x: 100 + 32 * i,
    y: 77,
    length: 200,
    range: (-125.0..125.0),
    name: "Slider #{i}",
    inital_value: 10
    )
  end
  sliders[0].bar_width(30)
  sliders[0].widget_colors(color('#930303'), color('#FF0000'))
  sliders[1].bar_width(30)
  sliders[1].widget_colors(color('#5BCE4D'), color('#1CFF00'))
  sliders[2].bar_width(30)
  sliders[2].widget_colors(color('#4439C9'), color('#9990FF'))
end
