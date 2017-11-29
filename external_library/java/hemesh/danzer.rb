load_library :hemesh

java_import 'wblut.core.WB_Version'
java_import 'wblut.core.WB_Disclaimer'
java_import 'wblut.geom.WB_Danzer'
java_import 'wblut.geom.WB_Point'
java_import 'wblut.processing.WB_Render3D'

attr_reader :render, :danzerA, :danzerB, :danzerC, :scale

def settings
  size(1000, 1000, P3D)
  smooth(8)
end

def setup
  sketch_title 'Aperiodic Tiling after Ludwig Danzer'
  stroke_weight(1.4)
    no_fill
    @render = WB_Render3D.new(self)
    puts WB_Version::version
    puts WB_Disclaimer::disclaimer
    @scale = 550
    @danzerA=WB_Danzer.new(scale, WB_Danzer::Type::A, WB_Point.new(-250,0,0))
    danzerA.inflate(3)
    @danzerB=WB_Danzer.new(scale, WB_Danzer::Type::B)
    danzerB.inflate(3)
    @danzerC=WB_Danzer.new(scale, WB_Danzer::Type::C, WB_Point.new(250,0,0))
    danzerC.inflate(3)
end

def draw
  background(55)
  translate(width / 2, height / 2)
  stroke(0)
  render.drawTriangle2D(danzerA)
  render.drawTriangle2D(danzerB)
  render.drawTriangle2D(danzerC)
end
