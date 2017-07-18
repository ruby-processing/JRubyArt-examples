load_library :control_panel

attr_reader :hide, :panel, :shouting

def setup
  sketch_title 'Simple Checkbox'
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title 'Checkbox'
    c.checkbox :shouting
    @panel = c
  end
  text_font(create_font('mono', 48))
  fill(200, 0, 0)
end

def warning
  shouting ? 'WARNING!' : 'warning!'
end

def draw
  background 0
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  text(warning, 20, 100)
end

def settings
  size 300, 300
end
