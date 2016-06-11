#!/usr/bin/env ruby
require_relative '../lib/common'
require_relative '../test/test_base'
require_relative '../test/page_test'
require_relative '../test/redirect_test'

$logger.info 'Trying to detect varnish ips'
varnish_ips = []
varnish_ips << execute_and_show_cmd('docker inspect odaniaportal_varnish_1 | grep IPAddress | cut -d \" -f 4;').strip
varnish_ips << execute_and_show_cmd('docker inspect odaniaportal_varnish_2 | grep IPAddress | cut -d \" -f 4;').strip
$logger.info "Ips: #{varnish_ips.join(', ')}"

$logger.info 'Testing redirects'
redirect_test = RedirectTest.new(varnish_ips, $test_config.redirects)
redirect_errors = redirect_test.check

$logger.info 'Testing pages'
page_test = PageTest.new(varnish_ips, $test_config.sites)
page_errors = page_test.check

$logger.info 'Finished processing! Result:'
has_errors = false

unless redirect_errors.empty?
	has_errors = true
	$logger.error 'Found invalid redirects'
	redirect_errors.each_pair do |type, error_data|
		$logger.error "Error: #{type}"

		error_data.each do |line|
			$logger.error line
		end
	end
end

unless page_errors.empty?
	has_errors = true
	$logger.error 'Found invalid pages'
	page_errors.each_pair do |host, host_errors|
		$logger.error ''
		$logger.error "Host: #{host}"

		host_errors.each_pair do |type, error_data|
			$logger.error " - Error: #{type}"

			error_data.each do |line|
				$logger.error line
			end
		end
	end
end


if has_errors
	exit 1
else
	$logger.info 'All ok'
end
