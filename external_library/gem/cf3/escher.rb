require 'cf3'

def setup_the_birds
  @birds= ContextFree.define do
    ############ Begin defining custom terminal, an wavy_triangle triangle
    class << self
      SQRT3 = Math.sqrt(3)
      define_method(:wavy_diamond) do |some_options| # wavy_triangle triangle
        options = self.get_shape_values(some_options)
        size = options[:size]
        rot = options[:rotation]
        x0 = options[:x]
        y0 = options[:y]
        disp = options[:disp]
        col = options[:color]
        pts = Array.new(16)
        pts[0] = Vec2D.new(x0 - 0.25 * size, y0 - size / SQRT3)       # A
        pts[2] = Vec2D.new(x0 + 0.75 * size, y0 - size / SQRT3)       # B
        pts[4] = Vec2D.new(x0 + 0.25 * size, y0 + (SQRT3 * size) / 6) # C
        pts[6] = Vec2D.new(x0 - 0.75 * size, y0 + (SQRT3 * size) / 6) # D
        pts[1] = get_mid_point(pts[0], pts[2])#Ab
        pts[3] = get_mid_point(pts[2], pts[4])#Bc
        pts[5] = get_mid_point(pts[4], pts[6])#Cd
        pts[7] = get_mid_point(pts[6], pts[0])#Da
        pts[8] = get_mid_point(pts[0], pts[1])#Aba
        pts[8] += adjust_bezier(PI/2, -disp * size)#Aba
        pts[9] = get_mid_point(pts[1], pts[2])
        pts[9] += adjust_bezier(PI/2, disp * size)
        pts[10] = get_mid_point(pts[2], pts[3])
        pts[10] += adjust_bezier(PI/3, disp * size)
        pts[11] = get_mid_point(pts[3], pts[4])
        pts[11] += adjust_bezier(PI/3, -disp * size)
        pts[12] = get_mid_point(pts[4], pts[5])
        pts[12] += adjust_bezier(PI/2, disp * size)
        pts[13] = get_mid_point(pts[5], pts[6])
        pts[13] += adjust_bezier(PI/2, -disp * size)
        pts[14] = get_mid_point(pts[6], pts[7])
        pts[14] += adjust_bezier(PI/3, -disp * size)
        pts[15] = get_mid_point(pts[7], pts[0])
        pts[15] += adjust_bezier(PI/3, disp * size)
        rotate(rot) if rot
        fill *col
        begin_shape
        vertex(pts[0].x, pts[0].y)
        bezier_vertex(pts[0].x, pts[0].y, pts[8].x, pts[8].y, pts[1].x, pts[1].y)
        bezier_vertex(pts[1].x, pts[1].y, pts[9].x, pts[9].y, pts[2].x, pts[2].y)
        bezier_vertex(pts[2].x, pts[2].y, pts[10].x, pts[10].y, pts[3].x, pts[3].y)
        bezier_vertex(pts[3].x, pts[3].y, pts[11].x, pts[11].y, pts[4].x, pts[4].y)
        bezier_vertex(pts[4].x, pts[4].y, pts[12].x, pts[12].y, pts[5].x, pts[5].y)
        bezier_vertex(pts[5].x, pts[5].y, pts[13].x, pts[13].y, pts[6].x, pts[6].y)
        bezier_vertex(pts[6].x, pts[6].y, pts[14].x, pts[14].y, pts[7].x, pts[7].y)
        bezier_vertex(pts[7].x, pts[7].y, pts[15].x, pts[15].y, pts[0].x, pts[0].y)
        vertex(pts[0].x, pts[0].y)
        end_shape(CLOSE)
        rotate(-rot) if rot
      end

      private
      def adjust_bezier(theta, disp)
        Vec2D.new(Math.cos(theta)*disp, Math.sin(theta)*disp)
      end

      def get_mid_point(a, b)
        (a + b) / 2.0
      end
    end

    ########### End definition of custom terminal 'wavy_diamond' shape
    shape :birds do
      bird size: 0.1
      split do
        10.times do |i|
          split do
            10.times do |j|
              bird size: 1, x: (i * 0.5 + 0.25 * (j%2)), y: j * 0.435
              rewind
            end
            rewind
          end
        end
      end
    end

    shape :bird do
      wavy_diamond color: [38, 1, 1, 1]
    end

    shape :bird do
      wavy_diamond color: [180, 1, 1, 1]
    end

    shape :bird do
      wavy_diamond color: [36, 1, 1, 1]
    end

    shape :bird do
      wavy_diamond color: [0.2, 1, 1, 1]
    end

    shape :bird do
      wavy_diamond color: [0.01, 1, 1, 1]
    end
  end
end

def settings
  size 1000, 800
end

def setup
  sketch_title 'In pursuit of M.C. Escher'
  setup_the_birds
  draw_it
end

def draw_it
  background 255
  @birds.render :birds, :start_x => 0, :start_y => 0, size: 1000, :disp => 0.32, color: [0, 1, 1, 1]
end

def draw
  # do nothing
end
