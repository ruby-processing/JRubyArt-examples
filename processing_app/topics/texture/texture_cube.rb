# Texture Cube
# by Dave Bollinger, translated to JRubyArt by Martin Prout.
#
# Drag mouse to rotate cube. Demonstrates use of u/v coords in
# vertex and effect on texture.
attr_reader :tex

def setup
  ArcBall.init(self)
  @tex = loadImage(data_path('berlin-1.jpg'))
  texture_mode(NORMAL)
  fill(255)
  stroke(color(44,48,32))
end

def draw
  background(0)
  no_stroke
  scale(90)
  textured_cube(tex)
end

def textured_cube(tex)
  begin_shape(QUADS)
  texture(tex)
  # Given one texture and six faces, we can easily set up the uv coordinates
  # such that four of the faces tile 'perfectly' along either u or v, but the other
  # two faces cannot be so aligned.  This code tiles 'along' u, 'around' the X/Z faces
  # and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  # rotation along the X axis will put the 'top' of either texture at the 'top'
  # of the screen, but is not otherwised aligned with the X/Z faces. (This
  # just affects what type of symmetry is required if you need seamless
  # tiling all the way around the cube)
  # +Z 'front' face
  vertex(-1, -1,  1, 0, 0)
  vertex( 1, -1,  1, 1, 0)
  vertex( 1,  1,  1, 1, 1)
  vertex(-1,  1,  1, 0, 1)
  # -Z 'back' face
  vertex( 1, -1, -1, 0, 0)
  vertex(-1, -1, -1, 1, 0)
  vertex(-1,  1, -1, 1, 1)
  vertex( 1,  1, -1, 0, 1)
  # +Y 'bottom' face
  vertex(-1,  1,  1, 0, 0)
  vertex( 1,  1,  1, 1, 0)
  vertex( 1,  1, -1, 1, 1)
  vertex(-1,  1, -1, 0, 1)
  # -Y 'top' face
  vertex(-1, -1, -1, 0, 0)
  vertex( 1, -1, -1, 1, 0)
  vertex( 1, -1,  1, 1, 1)
  vertex(-1, -1,  1, 0, 1)
  # +X 'right' face
  vertex( 1, -1,  1, 0, 0)
  vertex( 1, -1, -1, 1, 0)
  vertex( 1,  1, -1, 1, 1)
  vertex( 1,  1,  1, 0, 1)
  # -X 'left' face
  vertex(-1, -1, -1, 0, 0)
  vertex(-1, -1,  1, 1, 0)
  vertex(-1,  1,  1, 1, 1)
  vertex(-1,  1, -1, 0, 1)
  end_shape
end

def settings
  size(640, 360, P3D)
end
