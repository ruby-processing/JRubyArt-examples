load_library :VideoExport
include_package 'com.hamoid'

VideoExport
attr_reader :pg, :video_export

def settings
  size(600, 600)
end

def setup
  sketch_title 'Create Graphics'
  @pg = createGraphics(640, 480)
  @video_export = VideoExport.new(self, data_path('pgraphics.mp4'), pg)
  video_export.start_movie
end

def draw
  background(0)
  text(format('exporting video %d', frame_count), 50, 50)
  pg.begin_draw
  pg.background(color('#224488'))
  pg.rect(pg.width * noise(frame_count * 0.01), 0, 40, pg.height)
  pg.end_draw
  video_export.save_frame
end

def key_pressed
  return unless (key == 'q')
  video_export.end_movie
  exit
end
