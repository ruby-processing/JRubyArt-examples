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
  shapeOne = createShape(ELLIPSE, 0, 0, 20, 20)
  shapeOne.setFill(web[:pinking])
  shapeTwo = createShape(GROUP)
  one = createShape(ELLIPSE, 42, 42, 20, 20)
  one.setFill(web[:pinking])
  two = createShape(ELLIPSE, 21, 21, 20, 20)
  one.setFill(web[:yolk])
  shapeTwo.addChild(one)
  shapeTwo.addChild(two)
  shapeThree = createShape(GROUP)
  base = createShape(ELLIPSE, 0, 0, 20, 20)
  base.setFill(web[:pinking])
  three = createShape(ELLIPSE, 21, 21, 20, 20)
  three.setFill(web[:pinking])
  four = createShape(ELLIPSE, 42, 42, 20, 20)
  four.setFill(web[:yolk])
  shapeThree.addChild(base)
  shapeThree.addChild(three)
  shapeThree.addChild(four)
  shapeFour = createShape(GROUP)
  five = createShape(ELLIPSE, 0, 0, 20, 20)
  five.setFill(web[:pinking])
  six = createShape(ELLIPSE, 21, 21, 20, 20)
  six.setFill(web[:pinking])
  seven = createShape(ELLIPSE, 42, 42, 20, 20)
  seven.setFill(web[:pinking])
  eight = createShape(ELLIPSE, 63, 63, 20, 20)
  eight.setFill(web[:yolk])
  shapeFour.addChild(five)
  shapeFour.addChild(six)
  shapeFour.addChild(seven)
  shapeFour.addChild(eight)
  @shapes = [shapeOne, shapeTwo, shapeThree, shapeFour]
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
