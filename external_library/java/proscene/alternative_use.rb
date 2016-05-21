# Alternative Use.
# by Jean Pierre Charalambos.
#
# This example illustrates how to use proscene through inheritance.
#
# Press 'h' to display the key shortcuts and mouse bindings in the console.

load_library :proscene
include_package 'remixlab.proscene'
attr_reader :scene

def settings
  size(640, 360, P3D)
end

def setup
  sketch_title 'Alternative Use'
  # We instantiate our MyScene class defined below
  @scene = MyScene.new(self)
  # scene.init
end

# Make sure to define the draw method, even if it's empty.
def draw
end

class MyScene < Scene
  # We need to call super to instantiate the base class
  def initialize(p)
    super 
  end

  # Initialization stuff could have also been performed at
  # setup, once after the Scene object have been instantiated
  def init
    set_grid_visual_hint(false)
  end

  #Define here what is actually going to be drawn.
  def proscenium
    background(0)
    fill(204, 102, 0, 150)
    draw_torus_solenoid
  end
end
