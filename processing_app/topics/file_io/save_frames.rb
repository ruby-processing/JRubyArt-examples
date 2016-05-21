#
# Save Frames
# by Daniel Shiffman.
#
# This example demonstrates how to use saveFrame to render
# out an image sequence that you can assemble into a movie
# using the MovieMaker tool.
#

# A boolean to track whether we are recording are not
attr_reader :recording

def setup
  sketch_title 'Save Frames'
  @recording = false
  directory = 'output'
  Dir.mkdir(directory) unless File.exist?(directory)
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

  # If we are recording call saveFrame!
  # The number signs (#) indicate to Processing to
  # number the files automatically
  save_frame('output/frames####.png'.to_java(:String)) if recording
  # Let's draw some stuff to tell us what is happening
  # It's important to note that none of this will show up in the
  # rendered files b/c it is drawn *after* saveFrame
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
  smooth
end
