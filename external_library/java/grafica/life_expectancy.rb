# This example was motivated by the following posts:
#
# http://lisacharlotterost.github.io/2016/05/17/one-chart-tools/
# http://lisacharlotterost.github.io/2016/05/17/one-chart-code/
require 'csv'
load_library :grafica
java_import 'grafica.GPlot'
java_import 'grafica.GPointsArray'

attr_reader :gplot

def setup
  sketch_title 'Life Expectancy'
  # The file has the following format:
  # country,income,health,population
  # Central African Republic,599,53.8,4900274
  points = GPointsArray.new
  point_sizes = []
  # Load CSV file into an Array of Hash objects
  # headers: option indicates the file has a header row
  CSV.foreach(data_path('expectancy.csv'), headers: true) do |row|
    country = row['country']
    income = row['income'].to_f
    health = row['health'].to_f
    population = row['population'].to_i
    points.add(income, health, country)
    # The point area should be proportional to the country population
    # population = pi * sq(diameter/2)
    point_sizes << 2 * sqrt(population / (200_000 * PI))
  end
  @gplot = create_graph(points, point_sizes)
end

def create_graph(points, sizes)
  GPlot.new(self).tap do |gplot|
    gplot.set_dim(650, 300)
    gplot.set_title_text('Life expectancy related to average income')
    gplot.getXAxis.set_axis_label_text('Personal income ($/year)')
    gplot.getYAxis.set_axis_label_text('Life expectancy (years)')
    gplot.set_log_scale('x')
    gplot.set_points(points)
    gplot.set_point_sizes(sizes)
    gplot.activate_point_labels
    gplot.activate_panning
    gplot.activate_zooming(1.1, CENTER, CENTER)
  end
end

def draw
  # Clear Display
  background(255)
  # Draw the gplot
  gplot.begin_draw
  gplot.draw_box
  gplot.drawXAxis
  gplot.drawYAxis
  gplot.draw_title
  gplot.draw_grid_lines(GPlot::BOTH)
  gplot.draw_points
  gplot.draw_labels
  gplot.end_draw
end

def settings
  size(750, 410)
end
