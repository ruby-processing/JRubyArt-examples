# PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
#
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https://opensource.org/licenses/MIT
#
load_libraries :PixelFlow

java_import 'com.thomasdiewald.pixelflow.java.geometry.DwHalfEdge'
java_import 'com.thomasdiewald.pixelflow.java.geometry.DwIFSGrid'
java_import 'com.thomasdiewald.pixelflow.java.geometry.DwIndexedFaceSetAble'
# A demo to create a Subdivision Cube, and either render it by as usual,
# or convert it to a HalfEdge representation and use that for rendering and
# more complex mesh operations/iterations.
#
# Controls:
# key '1'-'7' ... subdivisions
# key 's      ... toggle stroke display

attr_reader :grid, :mesh, :shp_gizmo, :display_stroke
RADIUS = 200

def settings
  size(800, 800, P3D)
  smooth(8)
end

def setup
  ArcBall.init(self)
  create_mesh(4) # initial setting
  @display_stroke = true
  @shp_gizmo = nil
end

def create_mesh(subdivisions)
  @grid = DwIFSGrid.new(1<<subdivisions, 2<<subdivisions)
  @mesh = DwHalfEdge::Mesh.new(grid)
end

def draw
  lights
  directional_light(128, 96, 64, -500, -500, 1_000)
  background(64)
  display_gizmo(300)
  scale(RADIUS)
  if(display_stroke)
    stroke_weight(0.5 / RADIUS)
    stroke(0)
  else
    no_stroke
  end
  fill(255)
  # display the IFS-mesh (Indexed Face set)
  push_matrix
  translate(-1.5, 0)
  display_mesh(grid)
  pop_matrix
  # display the HalfEdge mesh
  push_matrix
  translate(1.5, 0)
  mesh.display(g)
  pop_matrix
  # info
  num_faces = mesh.ifs.get_faces_count
  num_verts = mesh.ifs.get_verts_count
  num_edges = mesh.edges.length
  format_string = 'Geometry Grid  [Verts %d]  [Faces %d]  [Half Edges %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, num_verts, num_faces, num_edges, frame_rate))
end

# this method can of course be optimized if we know in advance the number of
# vertices per face
def display_mesh(ifs)
  faces_count = ifs.get_faces_count
  faces       = ifs.get_faces
  verts       = ifs.get_verts
  faces.each do |face|
    case(face.length)
    when 3
      begin_shape(TRIANGLE)
      vertex(*verts[face[2]])
      vertex(*verts[face[1]])
      vertex(*verts[face[0]])
      end_shape
    when 4
      begin_shape(QUAD)
      vertex(*verts[face[3]])
      vertex(*verts[face[2]])
      vertex(*verts[face[1]])
      vertex(*verts[face[0]])
      end_shape
    else
      begin_shape # POLYGON
      face.each do |coord|
        vertex(*verts[face[coord]])
      end
      end_shape(CLOSE)
    end
  end
end

def create_gizmo(s)
  stroke_weight(1)
  create_shape.tap do |shp|
    shp.begin_shape(LINES)
    shp.stroke(255, 0, 0)
    shp.vertex(0, 0, 0)
    shp.vertex(s, 0, 0)
    shp.stroke(0, 255, 0)
    shp.vertex(0, 0, 0)
    shp.vertex(0, s, 0)
    shp.stroke(0, 0, 255)
    shp.vertex(0, 0, 0)
    shp.vertex(0, 0, s)
    shp.end_shape
  end
end

def display_gizmo(s)
  @shp_gizmo = create_gizmo(s) unless shp_gizmo
  shape(shp_gizmo)
end

def key_released
  case key
  when '1'..'7'
    create_mesh(key.to_i)
  when 's', 'S'
    @display_stroke = !display_stroke
  end
end
