require 'ruby_wordcram'

def settings
  size(600, 600)
end

def setup
  sketch_title 'Yin Yang Words'
  background 255
  image = load_image(data_path('yinyang.png'))
  image.resize(width, height)
  create_image_shaped_wordcram(
    image: image,
    mask: color('#000000'),
    words: repeat_word('flexible', 500),
    hue: color('#F5B502')
  )
  create_image_shaped_wordcram(
    image: image,
    mask: color('#ffffff'),
    words: repeat_word('usable', 500),
    hue: color('#782CAF')
  )
end

def create_image_shaped_wordcram(image:, mask:, words:, hue:)
  image_shape = ImageShaper.new.shape(image, mask)
  placer = ShapeBasedPlacer.new(image_shape)
  WordCram.new(self)
          .from_words(words.to_java(Word))
          .with_placer(placer)
          .with_nudger(placer)
          .sized_by_weight(4, 40)
          .angled_at(0)
          .with_color(hue)
          .draw_all
end

def repeat_word(word, times)
  (0..times).map do
    # Give the words a random weight, so they're sized differently.
    Word.new(word, rand)
  end
end
