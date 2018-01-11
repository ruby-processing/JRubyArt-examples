load_library :hemesh
%w[WB_Color WB_Render].each { |klass| java_import "wblut.processing.#{klass}" }
include_package 'wblut.hemesh'

NUM_POINTS = 100
attr_reader :points, :container, :cells, :render

def setup
  sketch_title 'Voronoi Cells Complex Cap'
  creator = HEC_Torus.new(120, 300, 6, 16)
  @container = HE_Mesh.new(creator)
  creator = HEC_Torus.new(60, 300, 6, 16)
  inner = HE_Mesh.new(creator)
  inner.modify(HEM_Extrude.new.setDistance(32).setChamfer(0.8))
  HET_MeshOp.flipFaces(inner)
  container.add(inner)
  container.smooth
  fitr = container.fItr
  fitr.next.setColor(color(0, 200, 50)) while fitr.hasNext
  array = (0...NUM_POINTS).map do
    [rand(-250..250.0), rand(-250..250.0), rand(-100..100.0)]
  end
  # converts multidimensional ruby Array to java
  @points = array.to_java(Java::double[])
  multiCreator = HEMC_VoronoiCells.new
  multiCreator.setPoints(points)
  multiCreator.setContainer(container)
  multiCreator.setOffset(10)
  @cells = multiCreator.create
  mItr = cells.mItr
  mesh = nil
  while mItr.hasNext
    mesh = mItr.next
    mesh.modify(HEM_HideEdges.new)
  end
  @render = WB_Render.new(self)
end

def draw
  background(55)
  directionalLight(255, 255, 255, 1, 1, -1)
  directionalLight(127, 127, 127, -1, -1, 1)
  translate(width / 2, height / 2)
  rotateY(mouseX * 1.0 / width * TWO_PI)
  rotateX(mouseY * 1.0 / height * TWO_PI)
  drawFaces
  drawEdges
end

def drawEdges
  stroke(0)
  render.drawEdges(cells)
end

def drawFaces
  no_stroke
  fill(255)
  mItr = cells.mItr
  mesh = nil
  fItr = nil
  drawFace = nil
  while mItr.hasNext
    mesh = mItr.next
    fItr = mesh.fItr
    while fItr.hasNext
      face = fItr.next
      if face.getInternalLabel == -1
        fill(WB_Color.spectralColorZucconi6(mesh.getInternalLabel * 2.6 + 420))
      else
        fill(WB_Color.spectralColorZucconi6(face.getInternalLabel * 2.6 + 420))
      end
      render.drawFace(face)
    end
  end
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
