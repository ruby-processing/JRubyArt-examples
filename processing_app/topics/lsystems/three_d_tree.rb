########################################################
# A 3D plant implemented using a
# Lindenmayer System in JRubyArt by Martin Prout
########################################################

load_libraries :stochastic_grammar, :control_panel
attr_reader :plant, :zoom, :rot_y, :panel, :hide

def setup
  sketch_title 'Three D Tree'
  camera(400.0, 500.0, 200.0, 0.0, -160.0, 0.0,
         0.0, 1.0, 0.0)
  setup_panel
  @plant = Plant.new
  plant.create_grammar(5)
  no_stroke
  @rot_y = 0
  @hide = false
end

def setup_panel
  control_panel do |c|
    c.title = 'Control:'
    c.look_feel 'Metal'
    c.slider :zoom, 1..8, 3
    c.slider :rot_y, -PI..PI, 0
    c.button :reset
    @panel = c
  end
end

def reset
  @rot_y = 0
  @zoom = 1
end

def draw
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  background(0)
  rotate_y rot_y
  scale zoom
  ambient_light(0, 255, 0)
  directional_light(0, 255, 0, 0.0, -1.0, 0.0)
  plant.render
end

############################
# Plant class
###########################
class Plant
  include Processing::Proxy
  attr_reader :grammar, :axiom, :production, :premis, :rule,
              :theta, :scale_factor, :distance, :phi

  def initialize
    @axiom = 'F'
    @grammar = StochasticGrammar.new(axiom)
    @production = axiom
    @premis = 'F'
    @rule = 'F[&+F]F[->F][->F][&F]'
    @scale_factor = 0.8
    @distance = 8
    @theta = 28.radians
    @phi = 28.radians
    grammar.add_rule(premis, rule)
    no_stroke
  end

  def render
    production.each_char do |ch|
      case ch
      when 'F'
        fill(0, 200, 0)
        translate(0, distance / -2, 0)
        box(distance / 4, distance, distance / 4)
        translate(0, distance / -2, 0)
      when '-'
        rotate_x(-theta)
      when '+'
        rotate_x(theta)
      when '&'
        rotate_y(-phi % TAU)
      when '>'
        rotate_z(phi % TAU)
      when '<'
        rotate_z(-phi)
      when '['
        push_matrix
        @distance = distance * scale_factor
      when ']'
        pop_matrix
        @distance = distance / scale_factor
      else
        puts("character '#{ch}' not in grammar")
      end
    end
  end

  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################

  def create_grammar(gen)
    @production = @grammar.generate gen
  end
end

def settings
  size(800, 800, P3D)
end

