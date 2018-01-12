load_library :hemesh
java_import 'wblut.processing.WB_Render3D'
include_package 'wblut.geom'
attr_reader :render, :gf, :voronoiXY, :points

def setup
  sketch_title 'Voronoi Example'
  @gf = WB_GeometryFactory.new
  @render = WB_Render3D.new(self)
  @points = []
  # add points to collection
  grid(10, 10) do |i, j|
    points << WB_Point.new(-270 + i * 60, -270 + j * 60, 0)
  end
  @voronoiXY = WB_Voronoi.getVoronoi2D(points, 2)
  font = create_font('Arial Bold', 18)
  text_font(font)
  text_align(CENTER)
end

def draw
  background(55)
  translate(width / 2, height / 2)
  no_fill
  stroke_weight(2)
  render.draw_point(points, 1)
  stroke_weight(1)
  voronoiXY.each { |vor| render.draw_polygon_edges(vor.get_polygon) }
  fill(200, 200, 0)
  text("click!", 0, 350)
end

def mousePressed
  points.each { |point| point.add_self(rand(-5..5.0), rand(-5..5.0), 0) }
  @voronoiXY = WB_Voronoi.getVoronoi2D(points, 2)
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
