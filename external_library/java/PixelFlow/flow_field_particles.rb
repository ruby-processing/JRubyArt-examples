load_libraries :PixelFlow, :video
%w[
  DwPixelFlow
  flowfieldparticles.DwFlowFieldParticles
  imageprocessing.DwOpticalFlow
  imageprocessing.filter.DwFilter
].each do |klass|
  java_import "com.thomasdiewald.pixelflow.java.#{klass}"
end
java_import 'processing.video.Capture'

# PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
# translated to JRubyArt by Martin Prout
# https://github.com/diwi/PixelFlow.git
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
# Particle Simulation + Optical Flow.
# The optical flow of a webcam capture is used as acceleration for the particles.
CAM_W = 640
CAM_H = 480
VIEWP_W = 1280
VIEWP_H = (VIEWP_W * CAM_H/ CAM_W).to_i

attr_reader :cam, :pg_canvas, :pg_obstacles, :pg_cam, :context, :opticalflow, :particles, :spawn

def settings
  size(VIEWP_W, VIEWP_H, P2D)
  no_smooth
end

def setup
  sketch_title 'warming up'
  surface.set_location(230, 0)
  @spawn = DwFlowFieldParticles::SpawnRect.new
  # capturing
  @cam = Capture.new(self, CAM_W, CAM_H, 30)
  cam.start
  @pg_cam = create_graphics(CAM_W, CAM_H, P2D)
  pg_cam.smooth(0)
  pg_cam.begin_draw
  pg_cam.background(0)
  pg_cam.end_draw
  @pg_canvas = create_graphics(width, height, P2D)
  pg_canvas.smooth(0)
  border = 20
  @pg_obstacles = create_graphics(width, height, P2D)
  pg_obstacles.smooth(0)
  pg_obstacles.begin_draw
  pg_obstacles.clear
  pg_obstacles.no_stroke
  pg_obstacles.blend_mode(REPLACE)
  pg_obstacles.rect_mode(CORNER)
  pg_obstacles.fill(0, 255)
  pg_obstacles.rect(0, 0, width, height)
  pg_obstacles.fill(0, 0)
  pg_obstacles.rect(border / 2, border / 2, width - border, height - border)
  pg_obstacles.end_draw
  # library context
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  # optical flow
  @opticalflow = DwOpticalFlow.new(context, CAM_W, CAM_H)
  opticalflow.param.grayscale = true
  #    border = 120
  dimx = width  - border
  dimy = height - border
  particle_size = 6
  numx = (dimx / (0.9 * particle_size)).to_i
  numy = (dimy / (0.9 * particle_size)).to_i
  # particle spawn-def, rectangular shape
  spawn.num(numx, numy)
  spawn.dim(dimx, dimy)
  spawn.pos(width / 2 - dimx / 2, height / 2 - dimy / 2)
  spawn.vel(0, 0)
  # particle simulation
  @particles = DwFlowFieldParticles.new(context, numx * numy)
  # particles.param.col_A = new float[]{0.40f, 0.80f, 0.10f, 3end
  # particles.param.col_B = new float[]{0.20f, 0.40f, 0.05f, 0end
  # particles.param.col_B = new float[]{0.80f, 0.40f, 0.80f, 0end
  particles.param.col_A = [0.25, 0.50, 1.00, 3.0]
  particles.param.col_B = [0.25, 0.10, 0.00, 0]
  particles.param.shader_type = 1
  particles.param.shader_collision_mult = 0.4
  particles.param.steps = 1
  particles.param.velocity_damping  = 0.999
  particles.param.size_display   = (particle_size * 1.5).ceil
  particles.param.size_collision = particle_size
  particles.param.size_cohesion  = particle_size
  particles.param.mul_coh = 0.20
  particles.param.mul_col = 1.00
  particles.param.mul_obs = 2.00
  particles.param.mul_acc = 0.10 # optical flow multiplier
  particles.param.wh_scale_obs = 0
  particles.param.wh_scale_coh = 5
  particles.param.wh_scale_col = 0
  # init stuff that doesn't change
  particles.resize_world(width, height)
  particles.spawn(width, height, spawn)
  particles.create_obstacle_flow_field(pg_obstacles, [0, 0, 0, 255], false)
  frame_rate(1_000)
end

def draw
  # capture camera frame + optical flow
  if cam.available
    cam.read
    pg_cam.begin_draw
    pg_cam.image(cam, 0, 0)
    pg_cam.end_draw
    # apply any filters
    DwFilter.get(context).luminance.apply(pg_cam, pg_cam)
    # compute Optical Flow
    opticalflow.update(pg_cam)
  end
  particles.param.timestep = 1.0 / frame_rate
  # update particles, using the opticalflow for acceleration
  particles.update(opticalflow.frameCurr.velocity)
  # render obstacles + particles
  pg_canvas.begin_draw
  pg_canvas.image(pg_cam, 0, 0, width, height)
  pg_canvas.image(pg_obstacles, 0, 0)
  pg_canvas.end_draw
  particles.display_particles(pg_canvas)
  # display result
  image(pg_canvas, 0, 0)
  format_string = 'Particles [%7.2f fps] [particles %d]'
  txt_fps = format(format_string, frame_rate, particles.get_count )
  surface.set_title(txt_fps)
end

def key_released
  particles.spawn(width, height, spawn)
end
