# After a sketch by Marc Edwards at Bjango
# https://github.com/bjango/Processing-SVG-experiments

load_library :svg

STEPS = 50.0
WEB = %w(#191030 #5ee4ff #764aed).freeze

attr_reader :distance, :angle, :palette

def setup
  sketch_title 'Sunflower Pattern'
  @palette = web_to_color_array(WEB)
  begin_record(SVG, data_path('sunflower.svg'))
  no_stroke
  no_loop
end

def draw
  background(palette[0])
  grid(STEPS, STEPS) do |i, j|
    @angle = j / STEPS * TAU + (i % 2 * TAU / STEPS / 2)
    @distance = ease_sine(i / STEPS) * 180
    fill(
      lerp_color(
        color(palette[1]),
        color(palette[2]),
        ease_steps(i / STEPS, 2 + rand(10))
      )
    )
    circle(
      width / 2 + (cos(angle) * distance),
      height / 2 + (sin(angle) * distance),
      1 + ease_sine(i / STEPS) * 8
    )
  end
  end_record
end

def ease_sine(t)
  1 + sin(PI / 2 * t - PI / 2)
end

def ease_steps(t, pow)
  t**pow
end

def settings
  size(400,400)
end
