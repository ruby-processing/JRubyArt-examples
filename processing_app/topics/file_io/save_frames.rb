attr_reader :recording

def setup
  sketch_title 'Save Frames'
  @recording = false
end

def draw
  background(0)
  # An arbitrary oscillating rotating animation
  # so that we have something to render
  (0...TAU).step(0.2) do |a|
    push_matrix
    translate(width / 2, height / 2)
    rotate(a + sin(frame_count * 0.004 * a))
    stroke(255)
    line(-100, 0, 100, 0)
    pop_matrix
  end
  # The '#' symbols makes Processing number the files automatically
  save_frame(data_path('output/frames####.png')) if recording
  # Let's draw some stuff to tell us what is happening
  # NB: Content created after this line does not show up rendered files
  text_align(CENTER)
  fill(255)
  if !recording
    text('Press r to start recording.', width / 2, height - 24)
  else
    text('Press r to stop recording.', width / 2, height - 24)
  end
  # A red dot for when we are recording
  stroke(255)
  recording ? fill(255, 0, 0) : no_fill
  ellipse(width / 2, height - 48, 16, 16)
end

def key_pressed
  # If we press r, start or stop recording!
  case key
  when 'r', 'R'
    @recording = !recording
  end
end

def settings
  size(640, 360)
end
