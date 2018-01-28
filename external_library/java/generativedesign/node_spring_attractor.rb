load_libraries :generativedesign

%w[Node Spring Attractor].each do |klass|
	java_import "generativedesign.#{klass}"
end
attr_reader :node_a, :node_b, :spring, :attractor

def  setup
	sketch_title 'Node Spring Attractor'
	lights
	fill(0)
	@node_a = Node.new(rand(width), rand(height), rand(-200..200))
	@node_b = Node.new(rand(width), rand(height), rand(-200..200))
	[node_a, node_b].each do |node|
		node.set_strength(-2)
		node.set_damping(0.1)
		node.set_boundary(0, 0, -300, width, height, 300)
	end
	@spring = Spring.new(node_a, node_b)
	spring.set_stiffness(0.7)
	spring.set_damping(0.9)
	spring.set_length(100)
	@attractor = Attractor.new(width / 2, height / 2, 0)
	attractor.set_mode(Attractor::SMOOTH)
	attractor.set_radius(200)
	attractor.set_strength(5)
end

def  draw
	background(255)
	if mouse_pressed?
		node_a.x = mouse_x
		node_a.y = mouse_y
		node_a.z = mouse_y - 256
	end
	# attraction between nodes
	node_a.attract(node_b)
	node_b.attract(node_a)
	# update spring
	spring.update
	# attract
	attractor.attract(node_a)
	attractor.attract(node_b)
	# update node positions
	node_a.update
	node_b.update
	# draw attractor
	stroke(0, 50)
	stroke_weight(1)
	no_fill
	line(attractor.x - 10, attractor.y, attractor.x + 10, attractor.y)
	line(attractor.x, attractor.y - 10, attractor.x, attractor.y + 10)
	ellipse(attractor.x, attractor.y, attractor.radius * 2, attractor.radius * 2)
	# draw spring
	stroke(255, 0, 0, 255)
	stroke_weight(4)
	line(node_a.x, node_a.y, node_a.z, node_b.x, node_b.y, node_b.z)
	# draw nodes
	no_stroke
	fill(0)
	push_matrix
	translate(node_a.x, node_a.y, node_a.z)
	sphere(20)
	pop_matrix
	push_matrix
	translate(node_b.x, node_b.y, node_b.z)
	sphere(20)
	pop_matrix
end

def  settings
	size(512, 512, P3D)
end
