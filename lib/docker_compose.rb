class DockerCompose
	def initialize(modules)
		@modules = modules
	end

	def start_and_scale
		DockerComposeTemplate.new(@modules).write(BASE_DIR)
		execute_and_show_cmd 'docker-compose up -d'

		$logger.info 'Scalling instances'
		execute_and_show_cmd 'docker-compose scale varnish=2 core=2 consul=2'
		@modules.keys.each do |name|
			execute_and_show_cmd "docker-compose scale #{name}=2"
		end

		$logger.info 'Current Docker Status'
		execute_and_show_cmd 'docker-compose ps'
	end

	def stop_and_rm
		execute_and_show_cmd 'docker-compose stop'
		execute_and_show_cmd 'docker-compose rm  -f'
	end

	def pull
		execute_and_show_cmd 'docker-compose pull'
	end
end
