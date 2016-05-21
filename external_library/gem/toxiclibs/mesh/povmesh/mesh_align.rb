require 'toxiclibs'

attr_reader :gfx, :vbo, :meshes
SCALE = 200
BOX_SIZE = TVec3D.new(5, 5, 50)

def settings
  size(600, 600, P3D)
end

def setup
  sketch_title('Mesh Align')
  ArcBall.init(self)
  @vbo = Gfx::MeshToVBO.new(self)
  no_stroke
  @meshes = create_shape(GROUP)
  600.times do |i|
    # create a new direction vector for each box
    dir = TVec3D.new(cos(i * TWO_PI / 75), sin(i * TWO_PI / 50), sin(i * TWO_PI / 25)).normalize
    # create a position on a sphere, using the direction vector
    pos = dir.scale(SCALE)
    # create a box mesh at the origin
    b = AABB.new(TVec3D.new, BOX_SIZE).to_mesh
    # align the Z axis of the box with the direction vector
    b.point_towards(dir)
    # move the box to the correct position
    b.transform(Toxi::Matrix4x4.new.translate_self(pos.x, pos.y, pos.z))
    b.compute_face_normals
    temp = vbo.mesh_to_shape(b, false)
    temp.disable_style
    temp.set_fill(color(rand(255), rand(255), rand(255)))
    meshes.add_child(temp)
  end
end

def draw
  background 50, 50, 200
  define_lights
  shape(meshes)
end

def define_lights
  lights
  shininess(16)
  directionalLight(255, 255, 255, 0, -1, 1)
  specular(255)
end