load_library :hype
%w[H HDrawablePool HSphere].freeze.each do |klass|
  java_import "hype.#{klass}"
end
java_import 'hype.extended.colorist.HColorField'
java_import 'hype.extended.layout.HGridLayout'

attr_reader  :color_field, :pool
POOL_COLS = 9
POOL_ROWS = 7
POOL_DEPTH = 9

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'Color Field Example'
  H.init(self)
  H.background(color('#242424'))
  H.use3D(true)
  @color_field = HColorField.new(width, height)
  .add_point(-300, 0, color('#FF0066'), 0.6)
  .add_point(width - 300, 0, color('#3300FF'), 0.6)
  .fill_only
  # .strokeOnly
  # .fillAndStroke
  @pool = HDrawablePool.new(POOL_COLS * POOL_ROWS * POOL_DEPTH)
  pool.auto_add_to_stage
  .add(HSphere.new)
  .layout(HGridLayout.new.start_x(-600).start_y(-450).start_z(-600).spacing(150, 150, 150).rows(POOL_ROWS).cols(POOL_COLS))
  .on_create do |obj|
    obj.size(40).stroke_weight(0).no_stroke.fill(0).anchor_at(H::CENTER)
  end
  .requestAll
end

def draw
  pool.each do |d|
    d.fill(0)
    color_field.apply_color(d)
  end
  lights
  sphere_detail(10)
  push_matrix
  translate(width / 2, height / 2, -800)
  rotate_y(frame_count.radians)
  H.draw_stage
  pop_matrix
end
