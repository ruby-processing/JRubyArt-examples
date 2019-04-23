require 'toxiclibs'

attr_reader :gfx, :voronoi, :img, :pixels
def setup
  sketch_title 'Monalisa Voronoi'
  @img = load_image(data_path('monalisa.jpg'))
  img.load_pixels
  @pixels = img.pixels
  @gfx = Gfx::ToxiclibsSupport.new(self)
  @voronoi = Toxi::Voronoi.new
  4_000.times do
    voronoi.add_point(TVec2D.new(rand(width), rand(height)))
  end
  no_loop
end

def draw
  voronoi.get_regions.each do |polygon|
    voronoi.get_sites.each do |vec|
      if polygon.contains_point(vec)
        fill pixels[vec.y * img.width + vec.x]
        gfx.polygon2D(polygon)
      end
    end
  end
  save_frame(data_path('mona-lisa-voronoi.png'))
end

def settings
  size(600, 894)
end
