attr_reader :digits, :index, :previous_x, :previous_y

def settings
  fullScreen
  # size(500, 500)
end

def setup
  sketch_title 'Visualizing PI'
  @index = 0
  @digits = File.read(data_path('pi-1million.txt')).split(//)
  color_mode(HSB)
  background(51)
  @previous_x = 0
  @previous_y = 0
end

def draw
  noStroke
  translate(width / 2, height / 2)
  rep = index > 500 ? 20 : 1
  rep.times do
    alpha = map1d(digits[index].to_i, 0..10, 0..360).to_i
    len = map1d(digits[index + 1].to_i, 0..9, 10..30)
    dx = DegLut.cos(alpha) * len
    dy = DegLut.sin(alpha) * len
    x = previous_x + dx.to_i
    y = previous_y + dy.to_i
    x = width / 2 if x > width / 2
    x = -width / 2 if x < -width / 2
    y = height / 2 if y > height / 2
    y = -height / 2 if y < -height / 2
    hue = map1d(digits[index + 2].to_i, 0..9, 0..255)
    fill(hue, 150, 255)
    ellipse(x, y, len, len)
    @previous_x = x
    @previous_y = y
    @index += 1
  end
end
