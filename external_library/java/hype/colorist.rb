load_library 'hype'
%w[H HDrawablePool HRect].freeze.each do |klass|
  java_import "hype.#{klass}"
end

%w[colorist.HPixelColorist layout.HGridLayout].freeze.each do |klass|
  java_import "hype.extended.#{klass}"
end

CELL_SIZE = 25

def settings
  size(618, 482)
end

def setup
  sketch_title 'Colorist'
  H.init(self)
  H.background(color('#242424'))

  colors = HPixelColorist.new(data_path('phil_pai.jpg'))
                         .fill_only
  # .strokeOnly
  # .fillAndStroke
  pool = HDrawablePool.new(576)
  pool.autoAddToStage
      .add(HRect.new.rounding(4))
      .layout(
        HGridLayout.new
                   .start_x(21)
                   .start_y(21)
                   .spacing(CELL_SIZE + 1, CELL_SIZE + 1)
                   .cols(24)
      )
      .on_create do |obj|
    obj.no_stroke.anchor_at(H::CENTER).size(CELL_SIZE)
    colors.applyColor(obj)
  end.request_all
  H.draw_stage
  no_loop
end
