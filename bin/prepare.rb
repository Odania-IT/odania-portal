#!/usr/bin/env ruby
require_relative '../lib/common'
require_relative '../lib/docker_compose_template'
require_relative '../lib/prepare_docker_modules'

$logger.info 'Trying to detect varnish ips'
varnish_ips = []
varnish_ips << execute_and_show_cmd('docker inspect odaniaportal_varnish_1 | grep IPAddress | cut -d \" -f 4;').strip
varnish_ips << execute_and_show_cmd('docker inspect odaniaportal_varnish_2 | grep IPAddress | cut -d \" -f 4;').strip
$logger.info "Ips: #{varnish_ips.join(', ')}"

$logger.info 'Preparing odania modules'
prepare_docker_modules = PrepareDockerModules.new($test_config.modules)
prepare_docker_modules.wait_for_consul_join
prepare_docker_modules.prepare
$logger.info 'Finished preparing'
