# Pie Chart
# By Ira Greenberg
#
# Uses the arc() function to generate a pie chart from the data
# stored in an array.

def setup
  sketch_title 'Pie Chart'
  background 100
  no_stroke
  diameter = [width, height].min * 0.75
  angles = [30, 10, 45, 35, 60, 38, 75, 67]
  rads = angles.map(&:radians) # map angles to radians
  angrads = angles.zip(rads)
  last_ang = 0.0
  angrads.each do |ar|
    fill ar[0] * 3.0
    arc width / 2, height / 2, diameter, diameter, last_ang, last_ang + ar[1]
    last_ang += ar[1]
  end
end

def settings
  size 640, 360
  smooth(4)
end
