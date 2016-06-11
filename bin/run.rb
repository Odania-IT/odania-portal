#!/usr/bin/env ruby
require_relative '../lib/common'

$logger.info 'Pulling, starting and scaling setup'
require_relative 'pull_and_create'

$logger.info 'Preparing setup'
require_relative 'prepare'

$logger.info 'Executing tests'
require_relative 'test'
