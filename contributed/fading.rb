load_libraries :my_dot, :color_group

NUM_ELEM = 100
PALETTE = %w[#F58F12 #0B9EE7 #4EA731 #F4D910 #F334E3 #202020]
attr_reader :my_dots, :frm, :save_anim, :group

def setup
  sketch_title 'Fading Arcs'
  @group = ColorGroup.from_web_array(PALETTE)
  colors = group.colors
  background(group.last)
  no_stroke
  @save_anim = false
  @my_dots = (0..NUM_ELEM).map do
    MyDot.new(
      Vect.new(rand(width), rand(height)),
      rand(10..20),
      colors[rand(5)],
      rand(TWO_PI)
    )
  end
end

def draw
  fill(group.last, 10)
  rect(0, 0, width, height)
  my_dots.each(&:display)
  return unless save_anim
  if ((frame_count % 4).zero? && frame_count < frm + 121)
    save_frame(data_path("image-###.png"))
  end
end

def key_pressed
  @save_anim = true
  @frm = frame_count
end

def mouse_clicked
  setup
end

def settings
  size(500, 500)
end
