load_library :control_panel

attr_reader :hide, :panel, :back

def setup
  sketch_title 'Simple Button'
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title 'Control Button'
    c.button :color_background # see method below
    c.button :exit! { exit } # example of a button with a simple block
    @panel = c
  end
  color_mode RGB, 1
  @back = [0, 0, 1.0]
end

def color_background
  @back = [rand, rand, rand]
end

def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  background *back
end

def settings
  size 300, 300
end
