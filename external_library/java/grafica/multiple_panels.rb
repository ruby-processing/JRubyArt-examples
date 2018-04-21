load_library :grafica
java_import 'grafica.GPlot'
java_import 'grafica.GPointsArray'

N_POINTS = 21
PANEL_DIM = [200, 200]
MARGINS = [60, 70, 40, 30]

def settings
  size(500, 500)
end

def setup
  sketch_title 'Multiple Panels'
  background(255)
  first_plot_pos = [0, 0]
  plot1 = GPlot.new(self)
  plot1.set_pos(*first_plot_pos)
  plot1.set_mar(0, MARGINS[1], MARGINS[2], 0)
  plot1.set_dim(*PANEL_DIM)
  plot1.set_axes_offset(0)
  plot1.set_ticks_length(-4)
  plot1.getXAxis.set_draw_tick_labels(false)

  plot2 = GPlot.new(self)
  plot2.set_pos(first_plot_pos[0] + MARGINS[1] + PANEL_DIM[0], first_plot_pos[1])
  plot2.set_mar(0, 0, MARGINS[2], MARGINS[3])
  plot2.set_dim(*PANEL_DIM)
  plot2.set_axes_offset(0)
  plot2.set_ticks_length(-4)
  plot2.getXAxis.set_draw_tick_labels(false)
  plot2.getYAxis.set_draw_tick_labels(false)
  plot3 = GPlot.new(self)
  plot3.set_pos(first_plot_pos[0], first_plot_pos[1] + MARGINS[2] + PANEL_DIM[1])
  plot3.set_mar(MARGINS[0], MARGINS[1], 0, 0)
  plot3.set_dim(*PANEL_DIM)
  plot3.set_axes_offset(0)
  plot3.set_ticks_length(-4)
  plot4 = GPlot.new(self)
  plot4.set_pos(first_plot_pos[0] + MARGINS[1] + PANEL_DIM[0], first_plot_pos[1] + MARGINS[2] + PANEL_DIM[1])
  plot4.set_mar(MARGINS[0], 0, 0, MARGINS[3])
  plot4.set_dim(*PANEL_DIM)
  plot4.set_axes_offset(0)
  plot4.set_ticks_length(-4)
  plot4.getYAxis.set_draw_tick_labels(false)

  # Prepare the points for the four plots
  points1 = GPointsArray.new(N_POINTS)
  points2 = GPointsArray.new(N_POINTS)
  points3 = GPointsArray.new(N_POINTS)
  points4 = GPointsArray.new(N_POINTS)

 N_POINTS.times do |i|
    points1.add(sin(TAU*i/(N_POINTS-1)), cos(TAU*i/(N_POINTS-1)))
    points2.add(i, cos(TAU*i/(N_POINTS-1)))
    points3.add(sin(TAU*i/(N_POINTS-1)), i)
    points4.add(i, i)
 end

  # Set the points, the title and the axis labels
  plot1.set_points(points1)
  plot1.getYAxis.set_axis_label_text("cos(i)")
  plot1.set_title_text("Plot with multiple panels")
  plot1.get_title.set_relative_pos(1)
  plot1.get_title.set_text_alignment(CENTER)

  plot2.set_points(points2)

  plot3.set_points(points3)
  plot3.getXAxis.set_axis_label_text("sin(i)")
  plot3.getYAxis.set_axis_label_text("i")
  plot3.setInvertedYScale(true)

  plot4.set_points(points4)
  plot4.getXAxis.set_axis_label_text("i")
  plot4.setInvertedYScale(true)
  # Draw the plots
  [plot1, plot2, plot3, plot4].each do |plot|
    plot.begin_draw
    plot.draw_box
    plot.drawXAxis
    plot.drawYAxis
    plot.draw_top_axis
    plot.draw_right_axis
    plot.draw_title
    plot.draw_points
    plot.draw_lines
    plot.end_draw
  end
end
