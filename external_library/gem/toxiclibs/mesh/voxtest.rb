require 'toxiclibs'

RES = 64

attr_reader :gfx, :mesh, :is_wireframe

# A factory wrapper can be used to create a more literate
# constructor for a java class (keyword args)
module Vector
  def self.create(args)
    TVec3D.new(args[:x], args[:y], args[:z])
  end
end

def settings
  size(1280, 720, P3D)
end

def setup
  sketch_title 'Voxelize Mesh'
  @gfx = Gfx::ToxiclibsSupport.new(self)
  ArcBall.init(self)
  init_mesh
end

def draw
  background(255)
  if !is_wireframe
    fill(255)
    no_stroke
    lights
  else
    gfx.origin(TVec3D.new, 100)
    no_fill
    stroke(0)
  end
  gfx.mesh_normal_mapped(mesh, !is_wireframe)
end

# creates a simple cube mesh and applies displacement subdivision
# on all edges for several iterations
def init_mesh
  @mesh = WETriangleMesh.new
  Toxi::AABB.new(Vector.create(x: 0, y: 0, z: 0), 100).to_mesh(mesh)
  5.times do |i|
    subdiv = Toxi::MidpointDisplacementSubdivision.new(
      mesh.compute_centroid,
      i.even? ? 0.35 : -0.2
    )
    mesh.subdivide(subdiv, 0)
  end
  mesh.compute_face_normals
  mesh.face_outwards
  mesh.compute_vertex_normals
end

# this function will first translate the mesh into a volumetric version
# this volumetric representation will constitute of a solid shell
# coinciding (albeit with loss of precision) with the original mesh
# the function then calculates a new mesh of an iso surface in this voxel space
# the original mesh will be discarded (overwritten)
#
# if you have enough RAM and would like less holes in the resulting surface
# try a higher voxel resolution (e.g. 128, 192) and/or increase wall thickness
def voxelize_mesh
  voxelizer = MeshVoxelizer.new(RES)
  # try setting to 1 or 2 (voxels)
  voxelizer.set_wall_thickness(0)
  vol = voxelizer.voxelize_mesh(mesh)
  vol.close_sides
  surface = HashIsoSurface.new(vol)
  @mesh = WETriangleMesh.new
  surface.compute_surface_mesh(mesh, 0.2)
  mesh.compute_vertex_normals
end

def key_pressed
  case key
  when 'w'
    @is_wireframe = !is_wireframe
  when 'l'
    LaplacianSmooth.new.filter(mesh, 1)
  when 'v'
    voxelize_mesh
  when 'r'
    init_mesh
  end
end
