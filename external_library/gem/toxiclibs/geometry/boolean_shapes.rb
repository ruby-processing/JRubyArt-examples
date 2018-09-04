require 'toxiclibs'
load_library :control_panel
attr_reader :gfx, :bool, :type, :polies
include Toxi

TYPE = [BooleanShapeBuilder::Type::UNION, BooleanShapeBuilder::Type::XOR].freeze
KEY = %w[union xor].freeze

def setup
  sketch_title 'Boolean Shapes'
  @gfx = Gfx::ToxiclibsSupport.new(self)
  @bool = KEY.zip(TYPE).to_h
  control_panel do |c|
    c.title 'Control Panel'
    c.menu :type, KEY, 'union'
  end
end

def draw
  background(160)
  builder = BooleanShapeBuilder.new(bool[type])
  phi = frame_count * 0.01
  builder.add_shape(Circle.new(mouse_x, mouse_y, 50))
  builder.add_shape(Ellipse.new(150, 130 + sin(phi) * 50, 120, 60))
  builder.add_shape(Rect.new(200 + sin(phi * 13 / 8) * 50, 180, 100, 100))
  builder.add_shape(
    Triangle2D.create_equilateral_from(
      TVec2D.new(50 + sin(phi * 15 / 13) * 50, 200), TVec2D.new(300, 200)
    )
  )
  builder.add_shape(
    Circle.new(100, 300, 50 + 30 * sin(phi * 21 / 15)).toPolygon2D(6)
  )
  fill(125)
  stroke(255, 0, 0)
  @polies = builder.compute_shapes
  polies.each { |p| gfx.polygon2D(p) }
end

def settings
  size(400, 400)
end
