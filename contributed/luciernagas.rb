# Luciernagas
# After an original by Marcel Miranda aka reaktivo
# https://github.com/reaktivo/rp-luciernagas
# translated and updated by Martin Prout for JRubyArt
# features use of Vec2D class and grid method
load_library :control_panel

attr_reader :panel, :hide, :image_mask, :spots
ACCURACY = 4

# Firefly holder
Flyer = Struct.new(:pos, :to_pos, :rotation, :positions)

def settings
  size 1024, 480, P2D
  smooth
end

def setup
  sketch_title 'Luciernagas'
  control_panel do |control|
    control.title 'Firefly Controller'
    control.look_feel 'Nimbus'
    control.slider(:speed, 0..20, 5)
    control.slider(:tail_length, 0..400, 30)
    control.slider(:rotation_max, 0..30, 7)
    control.slider(:target_radius, 5...100, 20)
    control.slider(:spot_distance, 5..200, 80)
    control.button :reset
    @panel = control
  end
  @hide = false
  @spotlight = create_spotlight
  @background = load_image(data_path('background.png'))
  @image_mask = load_image(data_path('mask.png'))
  load_spots(image_mask, ACCURACY)
  reset
end

def reset
  @flyers = (0..100).map { create_flyer }
end

def draw
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  image @background, 0, 0
  draw_lights
  draw_flyers
end

def draw_lights
  lights = create_graphics width, height, P2D
  lights.begin_draw
  @flyers.each do |flyer|
    lights.push_matrix
    position = flyer.pos
    lights.translate position.x, position.y
    lights.image @spotlight, -@spotlight.width / 2, -@spotlight.height / 2
    lights.pop_matrix
  end
  lights.end_draw
  image_mask.mask lights
  image image_mask, 0, 0
end

def draw_flyers
  rotation_max = @rotation_max / 100 * TWO_PI
  @flyers.each do |flyer|
    # check if point reached
    if flyer.pos.dist(flyer.to_pos) <  @target_radius
      spot = find_spot_near flyer.pos, @spot_distance
      flyer.to_pos = spot
    end
    # set new rotation
    to_rotation = (flyer.to_pos - flyer.pos).heading
    to_rotation = find_nearest_rotation(flyer.rotation, to_rotation)
    # rotate to new direction
    if flyer.rotation < to_rotation
      flyer.rotation = flyer.rotation + rotation_max
      flyer.rotation = to_rotation if flyer.rotation > to_rotation
    else
      flyer.rotation = flyer.rotation - rotation_max
      flyer.rotation = to_rotation if flyer.rotation < to_rotation
    end
    # add tail position
    flyer.positions << flyer.pos.dup
    flyer.positions.shift while flyer.positions.size > @tail_length
    # set flyer position
    flyer.pos.x = flyer.pos.x + @speed * cos(flyer.rotation)
    flyer.pos.y = flyer.pos.y + @speed * sin(flyer.rotation)
    # draw flyer tail
    draw_tail flyer
    # draw flyer
    no_stroke
    fill 201, 242, 2
    push_matrix
    translate flyer.pos.x, flyer.pos.y
    ellipse 0, 0, 5, 5
    pop_matrix
  end
end

def create_flyer
  spot = rand_spot
  to_spot = find_spot_near spot, @spot_distance
  rotation = rand * TWO_PI
  Flyer.new(spot, to_spot, rotation, [])
end

def draw_tail(flyer)
  positions = flyer.positions
  return unless positions && !positions.empty?
  alpha_add = (255 / positions.size).to_i
  positions.each_index do |i|
    stroke(255, i * alpha_add)
    if i < positions.size - 2
      line(positions[i].x, positions[i].y, positions[i + 1].x, positions[i + 1].y)
    end
  end
end

def load_spots(spot_image, accuracy = ACCURACY)
  @spots = []
  spot_image.load_pixels
  corner_color = spot_image.get 0, 0
  grid(spot_image.width, spot_image.height, accuracy, accuracy) do |x, y|
    color = spot_image.get(x, y)
    spots << Vec2D.new(x, y) if color != corner_color
  end
end

def rand_spot
  spots.sample
end

def find_spot_near(pos, distance)
  spot = Vec2D.new(Float::INFINITY, Float::INFINITY)
  spot = rand_spot until spot.dist(pos) < distance
  spot
end

def find_nearest_rotation(from, to)
  dif = (to - from) % TWO_PI
  if dif != dif % PI
    dif = dif < 0 ? dif + TWO_PI : dif - TWO_PI
  end
  from + dif
end

def create_spotlight
  size = 60
  spotlight = create_graphics size, size, P2D
  spotlight.begin_draw
  spotlight.no_stroke
  spotlight.fill 255, 60
  # spotlight.fill 255, 40
  half_size = size / 2
  spotlight.ellipse half_size, half_size, half_size, half_size
  spotlight.filter BLUR, 4
  spotlight.end_draw
  spotlight
end
