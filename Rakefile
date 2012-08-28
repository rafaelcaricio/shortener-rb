require 'rspec/core/rake_task'

namespace :spec do

  RSpec::Core::RakeTask.new(:app) do |t|
    t.rspec_opts = "--color"
    t.pattern = "spec/**/*_spec.rb"
  end

end
