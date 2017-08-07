load_libraries :library_proxy, :mouse_thing

attr_reader :mouse_proxy

def settings
  size(800, 600)
end

def setup
  sketch_title 'Mouse Event'
  frame_rate(1)
  MouseThing.new(self)
end

def draw
  background(255)
end
