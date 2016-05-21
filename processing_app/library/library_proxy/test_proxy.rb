# test_proxy.rb by Martin Prout
load_library :library_proxy
require_relative 'proxy_library'

def settings
  size 300, 300
end

def setup
  sketch_title 'Test LibraryProxy'
  TestProxy.new(self) # initialize our TestProxy Library
end

def draw
  background 0, 0, 200	
  fill 200, 0, 0
  ellipse 150, 150, 200, 100
end
