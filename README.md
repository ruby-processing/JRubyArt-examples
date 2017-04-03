# JRubyArt-examples for JRubyArt-1.3.0+
JRubyArt-examples
================

Rakefiles amended to use `-r` in place of `run`

Many of the vanilla processing example sketches have been translated to ruby-processing, and they are mainly written as 'bare' sketches (ie not class wrapped) in keeping with the original processing.  At runtime these sketches the get wrapped into a Sketch class. Should you prefer you can still write class wrapped sketches, these will work equally well with jruby_art. You should also checkout the [Nature of Code Examples in ruby][] and for the beginner [Learning Processing with Ruby][] for even more examples.
Includes autorun Rakefiles:-

1. in a console cd `k9_samples` directory
2. and `rake` to run all the core examples (excludes gem examples etc)
3. `rake hype` to just run the hype library examples (depends on an installed hype library). 
4. `rake wordcram` to just run the wordcram gem examples (depends on an installed ruby_wordcram gem).
5. `rake pbox2d` to just run the pbox2d gem examples (depends on an installed gem).

### Partial Catalogue (for the lazy)

1. [Basic][]

    1. [structure][]
    2. [objects][] 
    3. [arrays][]
    4. [input][]
    5. [shape][]
    6. [image][]
    7. [control][]

2. [Topics][]

    1. [shaders][]
    2. [lsystems][]
    3. [advanced data][]
    
3. [Libraries][]
    1. [fastmath][]
    2. [vecmath][]
    3. [control-panel][]
    4. [video][]

4. Gems
   1. [PBox2D][pbox2d]
   2. [Geomerative][geomerative]
   3. [Toxiclibs][toxiclibs]
   4. [Wordcram][wordcram]
   5. [Sunflow raytracing][joons]
   
5. Java Libraries
   1. [Hype-processing][hype]
   2. [Hemesh][hemesh]
6. Others
   1. [WOVNS patterns][wovns]

### User contributions are most welcome
[Contributions][] add your [own][]

[wovns]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/examples/WOVNS
[Learning Processing with Ruby]:https://github.com/ruby-processing/learning-processing-with-ruby
[Nature of Code Examples in ruby]:https://github.com/ruby-processing/The-Nature-of-Code-for-JRubyArt
[Contributions]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/contributed
[own]:https://github.com/ruby-processing/JRubyArt-examples/blob/master/CONTRIBUTING.md
[Basic]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics
[structure]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/structure
[objects]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/objects
[arrays]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/arrays
[control]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/control
[shape]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/shape
[input]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/input
[image]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/basics/image
[Topics]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/topics
[lsystems]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/topics/lsystems
[advanced data]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/topics/advanced_data
[shaders]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/topics/shaders
[Libraries]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/library
[fastmath]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/library/fastmath
[vecmath]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/library/vecmath
[video]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/processing_app/library/video
[control-panel]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/contributed/jwishy.rb
[PBox2D]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/ruby_gem/jbox2d
[hype]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/java/hype
[hemesh]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/java/hemesh
[joons]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/joonsrenderer
[geomerative]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/geomerative
[toxiclibs]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/toxiclibs
[wordcram]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/ruby_wordcram
