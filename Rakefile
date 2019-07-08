require 'fileutils'

K9WD = File.expand_path(__dir__)

desc 'run contributed samples'
task default: [:all]

desc 'run all autorun samples except hype'
task :all do
  Rake::Task[:contributed].execute
  Rake::Task[:vecmath].execute
  Rake::Task[:shaders].execute
  Rake::Task[:slider].execute
end

desc 'run contributed samples'
task :contributed do
  FileUtils.cd(File.join(K9WD, 'contributed'))
  system 'rake'
end

desc 'run vecmath samples'
task :vecmath do
  %w[vec2d vec3d arcball].each do |folder|
    FileUtils.cd(
      File.join(
        K9WD,
        'processing_app',
        'library',
        'vecmath',
        folder
      )
    )
    system 'rake'
  end
end

desc 'run shader samples'
task :shaders do
  FileUtils.cd(
    File.join(
      K9WD,
      'processing_app',
      'topics',
      'shaders'
    )
  )
  system 'rake'
end

desc 'run Hype Processing samples'
task :hype do
  FileUtils.cd(
    File.join(
      K9WD,
      'external_library',
      'java',
      'hype'
    )
  )
  system 'rake'
end

desc 'run WordCram samples'
task :wordcram do
  FileUtils.cd(
    File.join(
      K9WD,
      'external_library',
      'gem',
      'ruby_wordcram'
    )
  )
  system 'rake'
end

desc 'hemesh'
task :hemesh do
  FileUtils.cd(
    File.join(
      K9WD,
      'external_library',
      'java',
      'hemesh'
    )
  )
  system 'rake'
end

desc 'pbox2d'
task :pbox2d do
  FileUtils.cd(
    File.join(
      K9WD,
      'external_library',
      'gem',
      'pbox2d'
    )
  )
  system 'rake'
  %w[revolute_joint test_contact mouse_joint distance_joint].each do |folder|
    FileUtils.cd(
      File.join(
        K9WD,
        'external_library',
        'gem',
        'pbox2d',
        folder
      )
    )
    system "k9 -r #{folder}.rb"
  end
end
