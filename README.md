# JRubyArt-examples for JRubyArt-1.4.4+
Replaces `$app` with `Processing.app`, new `library_loader` (_but latter change should be transparent_).
Uses a simplified `control_panel` interface, ie use `c.title('PanelTitle')` instead of `c.title = 'PanelTitle'`, the old examples still work with the the latest version of JRubyArt, but these examples require the latest version.

Description
================

Like the original `ruby-processing`, `JRubyArt` is like a DSL for vanilla `processing`, so sketches can be written as **bare** sketches (ie they do not require a **class** wrapper, JRubyArt does that for you as does vanilla processing cf [propane][propane]). Here you will find many of the processing example sketches have been translated to ruby as **bare** sketches) but you can add a **class** wrapper if that suits you. You should also checkout the [Nature of Code Examples in ruby][] and for the beginner [Learning Processing with Ruby][] for even more examples. Many sketch folders includes autorun Rakefiles, and some of these can be run from the root directory as a demo:-

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
   6. [Skatolo Gui][skatolo]

5. Java Libraries
   1. [Hype-processing][hype]
   2. [Hemesh][hemesh]
   3. [PixelFlow][flow]
   4. [LiquidFunProcessing][liquid]
   5. [Handy][handy]

6. Others
   1. [WOVNS patterns][wovns]
   2. [Grid Method][grid]

### User contributions are most welcome
[Contributions][] add your [own][]

[handy]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/java/handy
[liquid]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/java/LiquidFunProcessing
[flow]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/java/PixelFlow
[wovns]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/examples/WOVNS
[grid]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/examples/grid_method
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
[skatolo]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/skatolo
[geomerative]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/geomerative
[toxiclibs]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/toxiclibs
[wordcram]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/gem/ruby_wordcram
[propane]:https://ruby-processing.github.io/propane/
