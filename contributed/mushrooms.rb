# 3D mushrooms by Nik
# http://www.local-guru.net/blog">guru</a>

def setup
  sketch_title 'Mushrooms'
  ArcBall.init self
end

def draw
  background(0)
  lights
  fill 127, 64, 0
  beginShape
  vertex(-100,100,-100)
  vertex(-100,100,100)
  vertex(100,100,100)
  vertex(100,100,-100)
  endShape

  draw_mushroom
  rotateY(PI)
  translate(10,35,0)
  scale(0.65)

  draw_mushroom

end

def draw_mushroom
  # stem
  fill 205, 199, 176
  noStroke
  (0..20).each do |i|

    beginShape(QUAD_STRIP)
    ofx1 = cos(i * PI / 20) * 20 + 20
    ofx2 = cos((i + 1) * PI / 20) * 20 + 20
    (0..11).each do |a|
      vertex(cos(a * PI / 5) * 10 + ofx1, 5 * i, sin(a * PI / 5) * 10)
      vertex(cos(a * PI / 5) * 10 + ofx2, 5 * (i+1), sin(a * PI / 5) * 10)
    end
    endShape
  end
  # cap

  pushMatrix
  translate(40,0,0)
  beginShape(TRIANGLE_STRIP)
  step = 10.radians
  alpha = 50
  (0..PI / 2).step(step) do |i|
    sini = sin(i)
    cosi = cos(i)
    sinip = sin((i + step))
    cosip = cos((i + step))
    (0..TWO_PI).step(step) do |j|
      sinj = sin(j)
      cosj = cos(j)
      sinjp = sin(j + step)
      cosjp = cos(j + step)
      # Upper hemisphere
      vertex(alpha * cosj * sini, alpha * -cosi, alpha * sinj * sini) # x, y, z
      vertex(alpha * cosjp * sini, alpha * -cosi, alpha * sinjp * sini)
      vertex(alpha * cosj * sinip, alpha * -cosip, alpha * sinj * sinip)
      vertex(alpha * cosjp * sinip, alpha * -cosip, alpha * sinjp * sinip)
    end
  end
  endShape
  popMatrix
end
def settings
  size(300,300,P3D)
end
