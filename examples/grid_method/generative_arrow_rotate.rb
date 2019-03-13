#
#  Example of using noise to rotate a grid of arrows
#
load_library :pdf
attr_reader :version, :time_seed, :save_one_frame, :arrow, :renderer
STEP = 40
POINTS = [
  Vec2D.new(0, -55),
  Vec2D.new(6, 0),
  Vec2D.new(16, 10),
  Vec2D.new(2, 10),
  Vec2D.new(0, -10),
  Vec2D.new(-2, 10),
  Vec2D.new(-16, 10),
  Vec2D.new(-6, 0)
].freeze

def setup
  sketch_title 'Generative Arrow'
  # resolution does not really matter since we are working with vectors
  frame_rate(35)
  @version = 0 # if we grab multiple frames, they will be numbered
  @time_seed = 0.1 # seed for the third dimension of the noise
  @save_one_frame = false
  create_arrow
end

def draw
  # turn on recording for this frame if we clicked the mouse
  begin_record(PDF, data_path("Line_#{version}.pdf")) if (save_one_frame == true)
  background(255)
  @time_seed = millis / 5000.0 # change noise over time
  grid(width, height, STEP, STEP) do |cx, cy|  # iterate down and accross the page
    push_matrix
    translate(cx + STEP / 2, cy + STEP / 2) # set the position of each arrow
    # rotate using noise
    rotate(4.0 * PI * noise(cx / 400.0, cy / 400.0, time_seed))
    # scale(1)
    shape(arrow) # draw our arrow
    pop_matrix
  end
  if (save_one_frame == true)
    end_record
    @save_one_frame = false
    @version += 1
  end
end

def mouse_pressed
  @save_one_frame = true
end

def create_arrow # custom shape for our arrow
  @arrow = create_shape
  @renderer ||= ShapeRender.new(arrow)
  arrow.begin_shape
  arrow.fill(200, 0, 0)
  arrow.no_stroke
  arrow.stroke_weight(2)
  POINTS.each { |pt| pt.to_vertex(renderer) }
  arrow.end_shape(CLOSE)
end

def settings
  size(1000, 1000)
end
