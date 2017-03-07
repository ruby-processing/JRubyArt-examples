require 'ruby_wordcram'

def settings
  size(800, 749)
end

def setup
  image = load_image(data_path('heart.png'))
  background 128
  image_shape = ImageShaper.new.shape(image, color('#000000'))
  placer = ShapeBasedPlacer.new(image_shape)
  WordCram.new(self)
          .from_text_file(data_path('kari-the-elephant.txt'))
          .with_placer(placer)
          .with_nudger(placer)
          .sized_by_weight(7, 40)
          .with_color(color('#ffffff'))
          .draw_all
  image_shape = ImageShaper.new.shape(image, color('#ffffff'))
  placer = ShapeBasedPlacer.new(image_shape)
  WordCram.new(self)
          .from_text_file(data_path('kari-the-elephant.txt'))
          .with_placer(placer)
          .with_nudger(placer)
          .sized_by_weight(7, 40)
          .with_color(color('#000000'))
          .draw_all
end
