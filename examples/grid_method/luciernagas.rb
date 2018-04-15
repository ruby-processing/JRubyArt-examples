# Luciernagas
# After an original by Marcel Miranda aka reaktivo
# https://github.com/reaktivo/rp-luciernagas
# translated and updated by Martin Prout for JRubyArt
# features use of Vec2D class and grid method
load_library :control_panel

attr_reader :image_mask, :positions
ACCURACY = 4

# Firefly holder
Flyer = Struct.new(:pos, :to_pos, :rotation, :tail)

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
    control.slider(:tail_length, 0..70, 30)
    control.slider(:rotation_max, 0..30, 7)
    control.slider(:target_radius, 5...100, 20)
    control.slider(:spot_distance, 10..100, 80)
    control.button :reset
  end
  @spotlight = create_spotlight
  @background = load_image(data_path('background.png'))
  @image_mask = load_image(data_path('mask.png'))
  load_positions(image_mask, ACCURACY)
  reset
end

def reset
  @flyers = (0..100).map { create_flyer }
end

def draw
  image @background, 0, 0
  draw_lights
  draw_flyers
end

def draw_lights
  lights = buffer(width, height, P2D) do |buffer|
    @flyers.each do |flyer|
      buffer.push_matrix
      position = flyer.pos
      buffer.translate position.x, position.y
      buffer.image @spotlight, -@spotlight.width / 2, -@spotlight.height / 2
      buffer.pop_matrix
    end
  end
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
    flyer.tail << flyer.pos.copy
    flyer.tail.shift while flyer.tail.length > @tail_length
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
  spot = positions.sample
  to_spot = find_spot_near spot, @spot_distance
  rotation = rand * TWO_PI
  Flyer.new(spot, to_spot, rotation, [])
end

def draw_tail(flyer)
  tail = flyer.tail
  return unless tail && !tail.empty?
  alpha_add = 100.0 / tail.length
  begin_shape(LINES)
  tail.each_with_index do |vec, i|
    stroke(color(255, i * alpha_add))
    vertex(vec.x, vec.y)
  end
  end_shape
end

def load_positions(spot_image, accuracy = ACCURACY)
  @positions = []
  spot_image.load_pixels
  grid(width, height, accuracy, accuracy) do |x, y|
    positions << Vec2D.new(x, y) if color(0) == spot_image.pixels[y * width + x]
  end
end

def find_spot_near(pos, distance)
  Vec2D.new.tap do |spot|
    spot.x = rand(0..width) # target width
    spot.y = rand(140.0..310) # target text area
    spot = positions.sample until spot.dist(pos) < distance
  end
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
  half_size = size / 2
  spotlight = buffer(size, size, P2D) do |buffer|
    buffer.no_stroke
    buffer.fill 255, 60
    # spotlight.fill 255, 40
    buffer.ellipse half_size, half_size, half_size, half_size
    buffer.filter BLUR, 4
  end
end
