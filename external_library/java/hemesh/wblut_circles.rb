load_library :hemesh

GEOM = %w[WB_Circle WB_GeometryOp WB_Point WB_RandomDisk WB_RandomPoint]
CORE = %w[WB_Disclaimer WB_Version]
CORE.each { |klass| java_import "wblut.core.#{klass}"}
GEOM.each { |klass| java_import "wblut.geom.#{klass}"}
java_import 'wblut.processing.WB_Render2D'
# Draw circles inside circle
# Demonstrates 2D circles in HE_Mesh
attr_reader :render, :generator, :circles
NUM_CIRCLES = 20
RADIUS = 250

def setup
  sketch_title 'WBlut Circles'
  stroke_weight(2)
  no_fill
  @render = WB_Render2D.new(self)
  puts WB_Version.version
  puts WB_Disclaimer.disclaimer
  # random points distributed uniformily inside disk with radius 250
  @generator = WB_RandomDisk.new.set_radius(RADIUS)
  @circles = (0..NUM_CIRCLES).map do
    point = generator.next_point
    # calculate radius: radius of disk - distance of center circle to center disk)
    rad = RADIUS - WB_GeometryOp.getDistance2D(point, WB_Point.ORIGIN)
    # create circle (center, radius)
    WB_Circle.new(point, rad)
  end
end

def draw
  background(55)
  translate(width / 2, height / 2)
  stroke(255, 0, 0)
  ellipse(0, 0, 2 * RADIUS, 2 * RADIUS)
  stroke(0)
  circles.each { |circle| render.drawCircle2D(circle) }
  # Replace one circle every frame
  point = generator.next_point
  rad = RADIUS - WB_GeometryOp.getDistance2D(point, WB_Point.ORIGIN)
  circles.shift
  circles << WB_Circle.new(point, rad)
end

def settings
  size(800, 800, P2D)
  smooth(8)
end

