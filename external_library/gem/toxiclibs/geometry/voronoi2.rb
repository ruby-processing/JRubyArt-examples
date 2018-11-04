require 'toxiclibs'
attr_reader :colors, :gfx, :voronoi

def setup
  sketch_title 'Colored Voronoi'
  @gfx = Gfx::ToxiclibsSupport.new(self)
  complement = Toxi::ComplementaryStrategy.new.create_list_from_color(TColor::BLUE)
  @colors = complement.to_a # a ruby Array of TColors
  @voronoi = Toxi::Voronoi.new
  50.times do
    voronoi.add_point(TVec2D.new(rand(width), rand(height)))
  end
end

def draw
  background 0
  stroke_weight 1
  stroke 255
  voronoi.get_regions.each do |polygon|
    fill colors.sample.toARGB
    gfx.polygon2D(polygon)
  end
  save_frame('voronoi-002.png')
  no_loop
end

def settings
  size 450, 360
end

def mouse_pressed
  loop
end
