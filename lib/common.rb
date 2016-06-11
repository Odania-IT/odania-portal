require 'erubis'
require 'hashie'
require 'httparty'
require 'logger'
require 'yaml'

BASE_DIR = File.absolute_path(File.join(File.dirname(__FILE__), '..')) unless defined? BASE_DIR

$logger = Logger.new STDOUT
$stdout.sync = true

def execute_and_show_cmd(cmd)
	result = `#{cmd}`
	$logger.info "Success? #{$?.success?} command: #{cmd}"
	unless $?.success?
		$logger.error "Error executing cmd: #{cmd}"
		$logger.error result
		exit 1
	end
	result
end

$test_config = Hashie::Mash.load File.join BASE_DIR, 'config', 'test.yml'
