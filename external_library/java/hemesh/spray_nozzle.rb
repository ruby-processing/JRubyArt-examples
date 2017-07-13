load_library :hemesh
java_import 'wblut.processing.WB_Render' # ren
include_package 'wblut.hemesh'
include_package 'wblut.geom'

attr_reader :mesh, :tree, :render, :modifier, :rnds, :random_ray, :growing

def setup
  sketch_title 'Spray Nozzle'
  ArcBall.init(self)
  @rnds = WB_RandomOnSphere.new
  create_mesh
  @render = WB_Render.new(self)
  @growing = true
end

def draw
  background(55)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  fill(255)
  no_stroke
  render.draw_faces(mesh)
  no_fill
  stroke(0, 50)
  render.draw_edges(mesh)
  fill(255, 0, 0)
  stroke(255, 0, 0)
  if growing
    20.times do
      grow
    end
  end
  return unless frame_count == 100
  mesh.subdivide(HES_CatmullClark.new)
  @growing = false
end

def create_mesh
  u = 6
  v = 12
  creator = HEC_Torus.new(50, 150, u, v)
  @mesh = HE_Mesh.new(creator)
  creator = HEC_Torus.new(40, -150, u, v)
  mesh.add(HE_Mesh.new(creator))
  @tree = WB_AABBTree.new(mesh, 10)
end

def grow
  @random_ray = WB_Ray.new(WB_Point.new(0, 0, -150), WB_Vector.new(rand(-1.0..1), rand(-1.0..1), rand(-1.0..1)))
  fint = HET_MeshOp.get_furthest_intersection(tree, random_ray)
  return unless fint
  point = fint.point
  point.add_mul_self(50, random_ray.get_direction)
  HEM_TriSplit.splitFaceTri(mesh, fint.face, point)
  @tree = WB_AABBTree.new(mesh, 10)
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
