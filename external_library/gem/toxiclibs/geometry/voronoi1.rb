require 'toxiclibs'
attr_reader :gfx, :voronoi

def setup
  sketch_title 'Basic Voronoi'
  @gfx = Gfx::ToxiclibsSupport.new(self)
  @voronoi = Toxi::Voronoi.new
  50.times do
    voronoi.add_point(TVec2D.new(rand(width), rand(height)))
  end
  no_loop
end

def draw
  background 0
  fill 0
  smooth
  stroke_weight 1
  stroke 255
  voronoi.get_regions.each {  |polygon| gfx.polygon2D(polygon) }
  save_frame(data_path('voronoi-001.png'))
end

def settings
  size 450, 360
end
