# Description:
# Boids Example demonstrates use of boid.angle (heading). 
# Usage:
# Drag mouse to steer 'invisible' flock attractor, use 'f' key to toggle flee
load_library :boids

attr_reader :radius

def settings
  full_screen
end

def setup
  sketch_title 'Boids Example'
  color_mode RGB, 1.0
  @radius = 0.02 * height
  @click = false
  @flocks = (0..3).map { Boids.flock(n: 20, x: 0, y: 0, w: width, h: height) }
end

def mouse_pressed
  @click = !@click
end

def key_pressed 
  return unless key == 'f'
  @flee = !@flee 
end

def draw
  background 0.4, 0.4, 1.0
  @flocks.each_with_index do |flock, i|
    flock.goal(target: Vec3D.new(mouse_x, mouse_y, 0), flee: @flee)
    flock.update(goal: 185, limit: 13.5)
    flock.each do |boid|
      r = radius + (boid.pos.z * 0.15)
      case i
      when 0 then fill 0.45, 0.45, 0.55
      when 1 then fill 0.55, 0.35, 0.35
      when 2 then fill 0.35, 0.55, 0.35
      end
      push_matrix
      point_array = (boid.pos.to_a).map { |p| p  - (r / 2.0) }
      translate point_array[X], point_array[Y]
      rotate(boid.angle)
      line(0, 0, r, r)  
      oval(0, 0, r, r)
      pop_matrix
    end
  end
end
