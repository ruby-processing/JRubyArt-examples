# -*- encoding: utf-8 -*-

root = File.expand_path(__dir__)

desc 'run contributed samples'    
task :default => [:all]

desc 'run all autorun samples except hype'
task :all do
  Rake::Task[:contributed].execute
  Rake::Task[:vecmath].execute  
  Rake::Task[:shaders].execute
  Rake::Task[:slider].execute
end

desc 'run contributed samples'
task :contributed do
  sh "cd #{root}/contributed && rake"
end

desc 'shaders'
task :shaders do
  sh "cd #{root}/processing_app/topics/shaders && rake"
end

desc 'vecmath'
task :vecmath do
  sh "cd #{root}/processing_app/library/vecmath/vec2d && rake"
  sh "cd #{root}/processing_app/library/vecmath/vec3d && rake"
  sh "cd #{root}/processing_app/library/vecmath/arcball && rake"
end

desc 'hype'
task :hype do
  sh "cd #{root}/external_library/java/hype && rake"
end

desc 'slider'
task :slider do
  sh "cd #{root}/processing_app/library/slider && rake"
end
