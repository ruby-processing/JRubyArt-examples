### Source of sketches ###
The current sketches are mainly variants on vanilla processing sketches by Joon Hyub Lee, the creator of the Joons renderer library, but you do not need to install the vanilla processing library, just install the joonsrenderer gem.  

### Joons Renderer Gem ###
This includes a modified version of the original Joons Library (and the interface is currently compatible with the original), but also includes an updated version of sunflow (jdk-8 and latest janino). To use the gem using standard incantation:-
```ruby
require 'joonsrenderer'
include_package 'joons' # this needs to in a module which is done automatically JRubyArt but not for propane
