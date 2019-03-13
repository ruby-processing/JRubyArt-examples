# Simple recursive branching system inspired by mycelium growth
# After an original sketch by Karsten Schmidt
# https://github.com/learn-postspectacular/sac-workshop-2013/blob/master/Mycelium/Mycelium.pde
# translated to JRubyArt by Martin Prout 2018

load_library :branch

attr_reader :renderer, :root

def setup
  @renderer = GfxRender.new(self.g)
  @root = Branch.new(
    self,
    Vec2D.new(0, height / 2),
    Vec2D.new(1, 0),
    10.0
  )
end

def draw
  background(0)
  root.run
end

def settings
  full_screen
end
