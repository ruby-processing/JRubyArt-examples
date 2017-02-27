# takes quite a long time to render
PALETTE = %w(#74AED7 #FFE4F3 #FEE597).freeze
COULEURS = %i(ciel pinking yolk).freeze
STEP = 84
attr_reader :shapes, :web

def settings
  size 2400, 6372, P2D
end

def setup
  sketch_title 'Random Grid'
  @web = COULEURS.zip(web_to_color_array(PALETTE)).to_h
  no_stroke
  shape_one = create_shape(ELLIPSE, 0, 0, 20, 20)
  shape_one.set_fill(web[:pinking])
  shape_two = create_shape(GROUP)
  one = create_shape(ELLIPSE, 42, 42, 20, 20)
  one.set_fill(web[:pinking])
  two = create_shape(ELLIPSE, 21, 21, 20, 20)
  one.set_fill(web[:yolk])
  shape_two.add_child(one)
  shape_two.add_child(two)
  shape_three = create_shape(GROUP)
  base = create_shape(ELLIPSE, 0, 0, 20, 20)
  base.set_fill(web[:pinking])
  three = create_shape(ELLIPSE, 21, 21, 20, 20)
  three.set_fill(web[:pinking])
  four = create_shape(ELLIPSE, 42, 42, 20, 20)
  four.set_fill(web[:yolk])
  shape_three.add_child(base)
  shape_three.add_child(three)
  shape_three.add_child(four)
  shape_four = create_shape(GROUP)
  five = create_shape(ELLIPSE, 0, 0, 20, 20)
  five.set_fill(web[:pinking])
  six = create_shape(ELLIPSE, 21, 21, 20, 20)
  six.set_fill(web[:pinking])
  seven = create_shape(ELLIPSE, 42, 42, 20, 20)
  seven.set_fill(web[:pinking])
  eight = create_shape(ELLIPSE, 63, 63, 20, 20)
  eight.set_fill(web[:yolk])
  shape_four.add_child(five)
  shape_four.add_child(six)
  shape_four.add_child(seven)
  shape_four.add_child(eight)
  @shapes = [shape_one, shape_two, shape_three, shape_four]
end

def draw
  background(web[:ciel]) # Sky blue
  grid(width, height, STEP, STEP) do |col, row|
    push_matrix
    translate col, row
    rkey = rand(0..6)
    shape(shapes[rkey]) if rkey < 4
    pop_matrix
  end
  save(data_path('random.png'))
  no_loop
end
