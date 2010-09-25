require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roogle"
    gem.summary = %Q{Google stuff on the command line}
    gem.description = %Q{Google stuff on the command line}
    gem.email = "ehren.murdick@gmail.com"
    gem.homepage = "http://github.com/ehrenmurdick/roogle"
    gem.authors = ["Ehren Murdick"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"

    gem.add_dependency "mechanize", ">= 1.0.0"
    gem.add_dependency "term-ansicolor", ">= 1.0.5"
    gem.add_dependency "launchy", ">= 0.3.7"

    gem.executables << 'roogle'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "roogle #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
