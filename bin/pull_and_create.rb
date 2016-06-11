#!/usr/bin/env ruby
require_relative '../lib/common'
require_relative '../lib/docker_compose'
require_relative '../lib/docker_compose_template'

docker_compose = DockerCompose.new($test_config.modules)
docker_compose.stop_and_rm
docker_compose.pull
docker_compose.start_and_scale
