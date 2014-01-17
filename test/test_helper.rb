ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
	# Add more helper methods to be used by all tests here...
	include FactoryGirl::Syntax::Methods
end

# Setup database cleaner
DatabaseCleaner.strategy = :truncation
module DatabaseCleanerModule
	def before_setup
		DatabaseCleaner.start
	end

	def after_teardown
		DatabaseCleaner.clean
	end
end

class MiniTest::Unit::TestCase
	include DatabaseCleanerModule
end
