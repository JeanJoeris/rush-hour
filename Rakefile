require "bundler"
Bundler.require

require "sinatra/activerecord/rake"
require 'rake/testtask'

namespace :test do
  desc "run all tests"
  task :all do
    Dir.glob('./test/*/*_test.rb') { |file| require file }
  end

  desc "run all model tests"
  task :models do
    Dir.glob('./test/models/*_test.rb') { |file| require file }
  end
  desc "run all controller tests"
  task :controllers do
    Dir.glob('./test/controllers/*_test.rb') { |file| require file }
  end
  desc "run all view tests"
  task :views do
    Dir.glob('./test/views/*_test.rb') { |file| require file }
  end
end

namespace :sanitation do
  desc "Check line lengths & whitespace with Cane"
  task :lines do
    puts ""
    puts "== using cane to check line length =="
    system("cane --no-abc --style-glob 'app/**/*.rb' --no-doc")
    puts "== done checking line length =="
    puts ""
  end

  desc "Check method length with Reek"
  task :methods do
    puts ""
    puts "== using reek to check method length =="
    system("reek -n app/**/*.rb 2>&1 | grep -v ' 0 warnings'")
    puts "== done checking method length =="
    puts ""
  end

  desc "Check both line length and method length"
  task :all => [:lines, :methods]
end
