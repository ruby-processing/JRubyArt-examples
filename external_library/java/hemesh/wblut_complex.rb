load_library :hemesh
%w[WB_Color WB_Render].each { |klass| java_import "wblut.processing.#{klass}" }
include_package 'wblut.hemesh'

NUM_POINTS = 100
attr_reader :container, :cells, :render

def setup
  sketch_title 'Voronoi Cells Complex Cap'
  creator = HEC_Torus.new(120, 300, 6, 16)
  @container = HE_Mesh.new(creator)
  creator = HEC_Torus.new(60, 300, 6, 16)
  inner = HE_Mesh.new(creator)
  inner.modify(HEM_Extrude.new.set_distance(32).set_chamfer(0.8))
  HET_MeshOp.flipFaces(inner)
  container.add(inner)
  container.smooth
  fitr = container.fItr
  fitr.next.setColor(color(0, 200, 50)) while fitr.has_next
  array = (0...NUM_POINTS).map do
    [rand(-250..250.0), rand(-250..250.0), rand(-100..100.0)]
  end
  # converts multidimensional ruby Array to java
  points = array.to_java(Java::double[])
  multi_creator = HEMC_VoronoiCells.new
  multi_creator.set_points(points)
  multi_creator.set_container(container)
  multi_creator.set_offset(10)
  @cells = multi_creator.create
  @render = WB_Render.new(self)
end

def draw
  background(55)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  translate(width / 2, height / 2)
  rotateY(mouseX * 1.0 / width * TWO_PI)
  rotateX(mouseY * 1.0 / height * TWO_PI)
  draw_faces
  draw_edges
end

def draw_edges
  stroke(0)
  render.draw_edges(cells)
end

def draw_faces
  no_stroke
  fill(255)
  mItr = cells.mItr
  while mItr.has_next
    mesh = mItr.next
    fItr = mesh.fItr
    while fItr.has_next
      face = fItr.next
      internal_label = face.get_internal_label
      if internal_label == -1
        fill(WB_Color.spectralColorZucconi6(mesh.get_internal_label * 2.6 + 420))
      else
        fill(WB_Color.spectralColorZucconi6(internal_label * 2.6 + 420))
      end
      render.draw_face(face)
    end
  end
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
