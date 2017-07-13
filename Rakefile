# -*- encoding: utf-8 -*-

K9WD = File.expand_path(__dir__)

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
  sh "cd #{K9WD}/contributed && rake"
end

desc 'shaders'
task :shaders do
  sh "cd #{K9WD}/processing_app/topics/shaders && rake"
end

desc 'vecmath'
task :vecmath do
  sh "cd #{K9WD}/processing_app/library/vecmath/vec2d && rake"
  sh "cd #{K9WD}/processing_app/library/vecmath/vec3d && rake"
  sh "cd #{K9WD}/processing_app/library/vecmath/arcball && rake"
end

desc 'hype'
task :hype do
  sh "cd #{K9WD}/external_library/java/hype && rake"
end

desc 'slider'
task :slider do
  sh "cd #{K9WD}/processing_app/library/slider && rake"
end

desc 'hemesh'
task :hemesh do
  sh "cd #{K9WD}/external_library/java/hemesh && rake"
end

desc 'pbox2d'
task :pbox2d do
  sh "cd #{K9WD}/external_library/gem/pbox2d && rake"
  sh "cd #{K9WD}/external_library/gem/pbox2d/revolute_joint && k9 -r revolute_joint.rb"
  sh "cd #{K9WD}/external_library/gem/pbox2d/test_contact && k9 -r test_contact.rb"
  sh "cd #{K9WD}/external_library/gem/pbox2d/mouse_joint && k9 -r mouse_joint.rb"
  sh "cd #{K9WD}/external_library/gem/pbox2d/distance_joint && k9 -r distance_joint.rb"
end

desc 'wordcram'
task :wordcram do
  sh "cd #{K9WD}/external_library/gem/ruby_wordcram && rake"
end
