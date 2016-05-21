# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
# Force directed graph
# Heavily based on: http://code.google.com/p/fidgen/
class Cluster
  extend Forwardable
  def_delegators(:@app, :line, :physics, :stroke, :stroke_weight)
  attr_reader :nodes, :diameter

  # We initialize a Cluster with a number of nodes, a diameter, and centerpoint
  def initialize(n, d, center)
    @diameter = d
    @app = $app
    # Create the nodes
    @nodes = (0..n).map { Node.new(center.add(TVec2D.randomVector)) }
    # Connect all the nodes with a Spring
    nodes[1..nodes.size - 1].each_with_index do |pi, i|
      nodes[0..i].each do |pj|
        physics.addSpring(Physics::VerletSpring2D.new(pi, pj, diameter, 0.01))
      end
    end
  end

  def display
    # Show all the nodes
    nodes.each(&:display)
  end

  # This functons connects one cluster to another
  # Each point of one cluster connects to each point of the other cluster
  # The connection is a "VerletMinDistanceSpring"
  # A VerletMinDistanceSpring is a spring which only enforces its rest length if the
  # current distance is less than its rest length. This is handy if you just want to
  # ensure objects are at least a certain distance from each other, but don't
  # care if it's bigger than the enforced minimum.
  def connect(other)
    other_nodes = other.nodes
    nodes.each do |pi|
      other_nodes.each do |pj|
        physics.addSpring(Physics::VerletMinDistanceSpring2D.new(pi, pj, (diameter + other.diameter) * 0.5, 0.05))
      end
    end
  end

  # Draw all the internal connections
  def internal_connections
    stroke(200, 0, 0, 80)
    nodes[0..nodes.size - 1].each_with_index do |pi, i|
      nodes[i + 1..nodes.size - 1].each do |pj|
        line(pi.x, pi.y, pj.x, pj.y)
      end
    end
  end

  # Draw all the connections between this Cluster and another Cluster
  def show_connections(other)
    stroke(200, 200, 0, 20)
    stroke_weight(2)
    other_nodes = other.nodes
    nodes.each do |pi|
      other_nodes[0..other_nodes.size - 1].each do |pj|
        line(pi.x, pi.y, pj.x, pj.y)
      end
    end
  end
end
