###############
# Frame of Reference example by Ira Greenberg
# https://github.com/irajgreenberg/ProcessingTips
# Translated to JRubyArt by Martin Prout February 2016
###############
load_library :geometry

FACE_COUNT = 50

attr_reader :c, :p

def settings
  size(800, 800, P3D)
end

def setup
  sketch_title 'Frame Of Reference'
  ArcBall.init(self) # so we use mouse to rotate sketch and mouse wheel to zoom
  @c = []
  @p = []
  FACE_COUNT.times do |i|
    # calc some random triangles in 3 space
    val = Vec3D.new(
      rand(-width / 2..width / 2),
      rand(-width / 2..width / 2),
      rand(-width / 2..width / 2)
    )
    v0 = Vec3D.new(
      rand(-val.x..-val.x + 100),
      rand(-val.y..-val.y + 100),
      rand(-val.z..-val.z + 100)
    )
    v1 = Vec3D.new(
      rand(-val.x..-val.x + 100),
      rand(-val.y..-val.y + 100),
      rand(-val.z..-val.z + 100)
    )
    v2 = Vec3D.new(
      rand(-val.x..-val.x + 100),
      rand(-val.y..-val.y + 100),
      rand(-val.z..-val.z + 100)
    )
    p << Plane.new([v0, v1, v2])
    # build some cute little cylinders
    c << Cylinder.new(Vec3D.new(150, 5, 5), 12)
    # Using each Triangle normal (N),
    # One of the Triangle's edges as a tangent (T)
    # Calculate a bi-normal (B) using the cross-product between each N and T
    # Note caps represent constants in ruby so we used N = nn, T = tt and B = bb
    # in the ruby code below

    #
    # A picture helps
    # nice, sweet orthogonal axes

    # N   B
    # |  /
    # | /
    # |/____T

    #
    # N, T, B together give you a Frame of Reference (cute little local
    # coordinate system), based on each triangle. You can then take the
    # cylinder (or any vertices) and transform them using a 3 x 3 matrix to
    # this coordinate system. (In the matrix each column is based on N, T and
    # B respecivley.) The transform will handle any rotations and scaling, but
    # not the translation, but we can add another dimenson to the matrix to
    # hold the translation values. Here's what all this confusing description
    # looks like:

    #
    # Matrix :                               Vector :
    # |  N.x  T.x  B.x  translation.x  |      |  x  |
    # |  N.y  T.y  B.y  translation.y  |      |  y  |
    # |  N.z  T.z  B.z  translation.z  |      |  z  |
    # |  0    0    0    1              |      |  1  |

    # We add the extra row in the matrix and the 1 to each vector
    # so the math works. We describe the Matrix as 4 rows by 4 columns
    # and the vector now as a Matrix with 4 rows and 1 column.
    # When you multiply matrices the inner numbers MUST match, so:
    # [4 x 4] [4 x 1] is OK, but [4 x 4] [1 x 4] is NOT COOL.
    # see mat4.rb where we use ruby Matrix to handle the multiplication for us

    nn = p[i].n
    tt = Vec3D.new(
      p[i].vecs[1].x - p[i].vecs[0].x,
      p[i].vecs[1].y - p[i].vecs[0].y,
      p[i].vecs[1].z - p[i].vecs[0].z
    )
    nn.normalize!
    tt.normalize!
    bb = nn.cross(tt)
    # build matrix with frame and translation (to centroid of each triangle)
    m4 = Mat4.new(xaxis: nn, yaxis: tt, zaxis: bb, translate: p[i].c)
    # transform each cylinder to align with each triangle
    c[i].vecs = m4 * c[i].vecs
  end
  fill(187)
  stroke(50, 20)
end

def draw
  background(0)
  lights
  p.each(&:display)
  c.each(&:display)
end

def renderer
  @renderer ||= AppRender.new(self)
end
