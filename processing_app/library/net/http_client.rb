require 'socket'

def settings
  size 200, 200
end

def setup
  sketch_title 'TCPSocket'
  host = 'www.ucla.edu'
  port = 80
  s = TCPSocket.open host, port
  s.send "GET / HTTP/1.1\r\n", 0
  s.puts "\r\n" 
  while line = s.gets
    puts line.chop
  end
  s.close
end
