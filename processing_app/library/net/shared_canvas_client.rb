# Shared Drawing Canvas (Client)
# by Alexander R. Galloway. Translated to JRubyArt by Martin Prout
#
# The Processing Client class is instantiated by specifying a remote address
# and port number to which the socket connection should be made. Once the
# connection is made, the client may read (or write) data to the server.
# NB: Start the Shared Drawing Canvas (Server) program first
#
load_library :net
include_package 'processing.net'

attr_reader :c

def settings
  size(450, 255)
end

def setup
  sketch_title 'Canvas Client'
  background(204)
  stroke(0)
  frame_rate(5) # Slow it down a little
  # Replace with your server's IP and port
  @c = Client.new(self, '127.0.0.1', 12_345)
end

def draw
  if mouse_pressed?
    # Draw our line
    stroke(255)
    line(pmouse_x, pmouse_y, mouse_x, mouse_y)
    # Send mouse coords to other person as spc separated string
    c.write(format("%f %f %f %f\n", pmouse_x, pmouse_y, mouse_x, mouse_y))
  end
  # Receive data from server
  return unless c.available > 0
  stroke 255, 0, 0
  input = c.read_string
  # Split input into an array of lines
  data = input.split("\n")
  # Split each line to array of string and convert to array of java float
  coords = data[0].split(' ').map(&:to_f).to_java(:float)
  # Draw line using received coords
  line(*coords)
end
