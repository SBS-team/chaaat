Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, :features, 'coveralls:push']