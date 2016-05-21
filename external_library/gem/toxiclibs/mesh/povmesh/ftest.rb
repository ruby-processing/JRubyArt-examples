require 'toxiclibs'

attr_reader :gfx, :mesh0, :mesh1, :mesh2, :fshape

def settings
  size(200, 200, P3D)
  smooth 8
end

def setup
  sketch_title('FTest')
  ArcBall.init(self)
  @gfx = Gfx::MeshToVBO.new(self)
  # define a rounded cube using the SuperEllipsoid surface function
  vert = AABB.fromMinMax(TVec3D.new(-1.0, -3.5, -1.0), TVec3D.new(1.0, 3.5, 1.0))
  box = AABB.fromMinMax(TVec3D.new(1.0, -1.5, -1.0), TVec3D.new(3.0, -3.5, 1.0))
  box2 = AABB.fromMinMax(TVec3D.new(1.0, 2.0, -1.0), TVec3D.new(3.0, 0.0, 1.0))
  @mesh0 = box.to_mesh
  @mesh1 = vert.to_mesh
  @mesh2 = box2.to_mesh # build a composite mesh
  mesh0.add_mesh(mesh1)
  mesh0.add_mesh(mesh2)
  mesh0.compute_face_normals
  fill(color('#c0c0c0')) # silver
  specular(20, 20, 20)
  ambient(100)
  no_stroke
  @fshape = gfx.mesh_to_shape(mesh0, false)
end

def draw
  background 80, 80, 160
  setup_lights
  scale(10)
  shape(fshape)
end

def setup_lights
  lights
  ambient_light(150, 150, 150)
  directional_light(100, 100, 100, -1, 0, 0)
  directional_light(100, 100, 100, 1, 0, -1)
end


def key_pressed
  case key
  when 'p', 'P'
    fileID = 'FTest'
    pm = Gfx::POVMesh.new(self)
    file = java.io.File.new(sketchPath(fileID + '.inc'))
    pm.begin_save(file)
    pm.set_texture(Gfx::Textures::CHROME)
    pm.saveAsPOV(mesh0.faceOutwards, false)
    pm.end_save 
  when 's', 'S'
    save_frame('FTest.png')
  end
end