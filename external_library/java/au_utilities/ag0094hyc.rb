# Andrew Glassner - www.glassner.com & www.imaginary-institute.com
# Translated to JRubyArt by Martin Prout class Ag009Hyc < Propane::App
  load_library :AULib
  include_package 'AULib'

  attr_reader :au_camera, :wave_x, :wave_y, :wave_phase
  GRID_RES = 20

  def settings
    size(500, 500)
  end

  def setup
    sketch_title 'Ag008Hyc'
    @au_camera = AUCamera.new(self, 300, 4, true)
    @wave_x = width / 2.0
    @wave_y = height / 2.0
    @wave_phase = 0
  end

  def get_wave(x, y)
    d = dist(wave_x, wave_y, x, y)
    side_dist = dist(wave_x, wave_y, 0, 0)
    angle = TWO_PI * d / side_dist
    map1d(sin(angle + wave_phase), (-1.0..1), (0.1..0.9))
  end

  def draw
    theta = au_camera.get_time
    @wave_phase = TWO_PI * (1 - theta)
    background(color(246, 250, 185))
    fill(color(95, 10, 40))
    no_stroke
    box_size = width * 2.0 / GRID_RES
    function = -> (count) { (1 + 2 * count) / (2.0 * GRID_RES) }
    (0...GRID_RES).each do |y|
      (-1...GRID_RES).each do |x|
        fx = function.call(x)
        fy = function.call(y)
        fx += 0.5 / GRID_RES if y.even?
        sx = width * fx
        sy = height * fy
        w = get_wave(sx, sy)
        angle = atan2(sy - (height / 2.0), sx - (width / 2.0))
        push_matrix
        translate(sx, sy)
        rotate(angle)
        ellipse(0, 0, w * box_size, (1 - w) * box_size)
        pop_matrix
      end
    end
    au_camera.expose
  end
