require 'geomerative'
attr_reader :grp, :ignoring_styles

def setup
  sketch_title 'Mouse Inside RShape?'
  RG.init(self)
  @ignoring_styles = false
  RG.ignore_styles(ignoring_styles)
  RG.set_polygonizer(RG.ADAPTATIVE)
  @grp = RG.load_shape(data_path('mapaAzimutal.svg'))
  grp.center_in(g, 100, 1, 1)
end

def draw
  translate(width / 2, height / 2)
  background(255)
  stroke(0)
  no_fill
  grp.draw
  # pre-cast to java, avoids issues with overloaded constructor
  point = [mouse_x - width / 2, mouse_y - height / 2].to_java(:float)
  p = RPoint.new *point
  grp.children.each do |child|
    next unless child.contains(p)
    RG.ignore_styles(true)
    fill(0, 100, 255, 250)
    no_stroke
    child.draw
    RG.ignore_styles(ignoring_styles)
  end
end

def mouse_pressed
  @ignoring_styles = !ignoring_styles
  RG.ignore_styles(ignoring_styles)
end

def settings
  size(600, 600)
end
