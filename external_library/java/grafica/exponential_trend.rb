# frozen_string_literal: true

load_library 'grafica'
java_import 'grafica.GPointsArray'
java_import 'grafica.GPlot'
java_import 'java.util.Random'

N_POINTS = 1_000
attr_reader :plot, :log_scale, :random, :points

def settings
  size(450, 450)
end

def setup
  sketch_title 'Exponential Trend'
  @random = Random.new
  # Prepare the points for the plot
  @points = GPointsArray.new(N_POINTS)
  @plot = GPlot.new(self)
  puts plot.inspect
  @log_scale = false
  N_POINTS.times do
    x_value = rand(10..200)
    y_value = 10**(0.015 * x_value)
    x_error = 2 * random.next_gaussian
    y_error = 2 * random.next_gaussian
    points.add(x_value + x_error, y_value + y_error)
  end
  # Create the plot
  plot.set_pos(25, 25)
  plot.set_dim(300, 300)
  # or all in one go
  # plot = GPlot.new(self, 25, 25, 300, 300)
  # Set the plot title and the axis labels
  plot.set_title_text('Exponential law')
  # NB: cannot use snake for getXAxis etc
  plot.getXAxis.set_axis_label_text('x')
  toggle_y_axis
  # Add the points to the plot
  plot.set_points(points)
  plot.set_point_color(color(100, 100, 255, 50))
end

def draw
  background(150)
  plot.begin_draw
  plot.draw_background
  plot.draw_box
  plot.drawXAxis
  plot.drawYAxis
  plot.draw_top_axis
  plot.draw_right_axis
  plot.draw_title
  plot.draw_points
  plot.end_draw
end

def toggle_y_axis
  y_axis = plot.getYAxis
  if log_scale
    plot.set_log_scale('y')
    y_axis.set_axis_label_text('log y')
  else
    plot.set_log_scale('')
    y_axis.set_axis_label_text('y')
  end  
end

def mouse_clicked
  @log_scale = !log_scale
  toggle_y_axis
end
