load_library :hemesh

java_import 'wblut.geom.WB_Point'
java_import 'wblut.geom.WB_RandomBox'
java_import 'wblut.geom.WB_RandomPoint'
java_import 'wblut.geom.WB_Triangulate'
java_import 'wblut.geom.WB_Triangulation3D'
java_import 'wblut.processing.WB_Render3D'

attr_reader :source, :render, :numPoints, :tetrahedra, :points

def setup
  sketch_title 'Triangulation 3D'
  ArcBall.init(self)
  @source = WB_RandomBox.new.setSize(500, 500, 500)
  @render = WB_Render3D.new(self)
  numPoints = 100
  @points = (0..numPoints).map { source.nextPoint }
  triangulation = WB_Triangulate.triangulate3D(points)
  @tetrahedra = triangulation.getTetrahedra() # 1D array of indices of tetrahedra, 4 indices per tetrahedron
  puts("First tetrahedron: [ #{tetrahedra[0]}, #{tetrahedra[1]}, #{tetrahedra[2]}, #{tetrahedra[3]} ]")
end

def draw
  background(55)
  directional_light(255, 255, 255, 1, 1, -1)
  directional_light(127, 127, 127, -1, -1, 1)
  center = (0...tetrahedra.length).step(4) do |i|
    push_matrix
    center = WB_Point.new(
      points[tetrahedra[i]]).addSelf(points[tetrahedra[i + 1]]).addSelf(points[tetrahedra[i + 2]]).addSelf(points[tetrahedra[i + 3]]).mulSelf(0.25 + 0.25 * sin(0.005 * frame_count)
    )
    render.translate(center)
    render.drawTetrahedron(points[tetrahedra[i]], points[tetrahedra[i + 1]], points[tetrahedra[i + 2]], points[tetrahedra[i + 3]])
    pop_matrix
  end
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
