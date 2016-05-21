# HTTP Client.
#
# Starts a network client that connects to a server on port 80,
# sends an HTTP 1.0 GET request, and prints the results.
# Note that this code is not necessary for simple HTTP GET request:
# Simply calling load_strings("http://www.processing.org") would do
# the same thing as (and more efficiently than) this example.
# This example is for people who might want to do something more
# complicated later.
load_library 'net'
include_package 'processing.net'

attr_reader :client, :data

def setup
  sketch_title 'Http Client'
  background(50)
  fill(200)
  # Connect to server on port 80
  @client = Client.new(self, 'www.ucla.edu', 80)
  # Use the HTTP "GET" command to ask for a Web page
  client.write("GET / HTTP/1.0\r\n")
  client.write("\r\n")
end

def draw
  return unless client.available > 0
  data = client.read_string # ...then grab it and print it
  puts data
end

def settings
  size(200, 200)
end

# @todo replace with a pure ruby alternative
