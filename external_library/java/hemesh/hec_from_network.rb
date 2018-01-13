load_library :hemesh

java_import 'wblut.processing.WB_Render'
include_package 'wblut.hemesh'
include_package 'wblut.geom'
attr_reader :mesh, :render

def setup
  sketch_title 'HEC From Network'
  # Creates a mesh from a frame. A WB_Frame is a collection of points and a
  # list of indexed connections.
  ArcBall.init(self)
  # Array of all points
  vertices = []
  grid(41, 41) do |i, j|
    vertices << [-400 + i * 20.0, -400 + j * 20.0,  sin(TWO_PI / 30 * i) * 40 + cos(TWO_PI / 25 * j) * 40]
  end
  # network = WB_Network.new(vertices)
  # For more control add the nodes one by one, a value can be given to each node for future use.
  network = WB_Network.new
  vertices.each_with_index do |vertex, i|
    # compromise on 2D noise for simplicity
    network.addNode(vertex[0], vertex[1], vertex[2], noise(0.1 * i, 0.1 * i))
  end
  grid(40, 40) do |i, j|
    network.addConnection(i + 41 * j, i + 1 + 41 * j) if rand(100) > 30
    network.addConnection(i + 41 * j, i + 41 * (j + 1)) if rand(100) > 30
  end
  # If the connections are known in advance these can be given as parameter as int[][].
  # The second index gives index of first and second point of connection in the points
  # array. network = WB_Network.new(vertices, connections)
  creator = HEC_FromNetwork.new
  creator.setNetwork(network)
  # alternatively you can specify a HE_Mesh instead of a WB_Network.
  creator.setConnectionRadius(6) # connection radius
  # number of faces in the connections, min 3, max whatever blows up the CPU
  creator.setConnectionFacets(6)
  # rotate the connections by a fraction of a facet. 0 is no rotation, 1 is a rotation over a full facet. More noticeable for low number of facets.
  creator.setAngleOffset(0.25)
  # Threshold angle to include sphere in joint.
  creator.setMinimumBalljointAngle(TWO_PI / 3.0)
  # divide connection into equal parts if larger than maximum length.
  creator.setMaximumConnectionLength(30)
  creator.setCap(true) # cap open endpoints of connections?
  creator.setTaper(true) # allow connections to have different radii at each end?
  creator.setCreateIsolatedNodes(false) # create spheres for isolated points?
  # use the value of the WB_Node as scaling factor, only useful if the frame was created using addNode.
  creator.setUseNodeValues(true)
  @mesh = HE_Mesh.new(creator)
  HET_Diagnosis.validate(mesh)
  @render = WB_Render.new(self)
end

def draw
  background(55)
  lights
  no_stroke
  render.draw_faces(mesh)
  stroke(0)
  render.draw_edges(mesh)
end

def settings
  size(1000, 1000, P3D)
  smooth(8)
end
