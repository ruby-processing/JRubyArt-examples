load_library :handy
java_import org.gicentre.handy.HandyRenderer

# Displays 4 sketchy rectangles with different hachuring styles.
# Version 2.0, 4th April, 2016
# Author Jo Wood

attr_reader :handy

def settings
  size(300,200)
end

def setup
  sketch_title 'Simple Hachure Styles'
  @handy = HandyRenderer.new(self)
  fill(206,76,52)
  handy.set_hachure_perturbation_angle(15)
end

def draw
  background(247,230,197)
  handy.set_roughness(1)
  handy.set_fill_gap(0.5)
  handy.set_fill_weight(0.1)
  handy.rect(50, 30, 80, 50)
  handy.set_fill_gap(3)
  handy.set_fill_weight(2)
  handy.rect(170, 30, 80, 50)
  handy.set_fill_gap(5)
  handy.set_is_alternating(true)
  handy.rect(50, 120, 80, 50)
  handy.set_roughness(3)
  handy.set_fill_weight(1)
  handy.set_is_alternating(false)
  handy.rect(170, 120, 80, 50)
  no_loop # No need to redraw.
end
