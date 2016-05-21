
def setup
  sketch_title 'Load Image'
  # The file "jelly.jpg" must be in the data folder
  # of the current sketch to load successfully
  @a = load_image 'jelly.jpg'    
  no_loop # Makes draw only run once
end

def draw
  image @a, 0, 0
  image @a, @a.width, 0, @a.width/2, @a.height/2
end

def settings
  size 300, 200
end
