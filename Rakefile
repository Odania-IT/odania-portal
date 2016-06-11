require 'rspec'
require 'capybara/rspec'

BASE_DIR = File.dirname(__FILE__)

begin
	require 'rspec/core/rake_task'
	RSpec::Core::RakeTask.new(:spec)
	task :default => :spec
rescue LoadError
	# no rspec available
end

# Import custom tasks to keep the main Rakefile small
Dir.glob('tasks/*.rake').each { |r| import r }

task :default => ['spec']
