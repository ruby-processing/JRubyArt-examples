load_library :control_panel

attr_reader :hide, :panel, :toggle_loop
def setup
  sketch_title 'Simple Menu'
  control_panel do |c|
    c.look_feel 'Motif'
    c.title 'Menu'
    c.menu :choice, %i[one two three]
    c.checkbox(:toggle_loop) { toggle_loop ? loop : no_loop}
    @panel = c
  end
end

def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  puts @choice
  no_loop
end

def settings
  size 300, 300
end
