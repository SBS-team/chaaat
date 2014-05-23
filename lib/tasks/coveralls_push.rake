require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, 'coveralls:push']

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do

  desc "Run the unit specs"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

  desc "Run the integration specs"
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = "spec/integration/**/*_spec.rb"
  end

end