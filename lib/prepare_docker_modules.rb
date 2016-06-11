class PrepareDockerModules
	def initialize(modules)
		@modules = modules #.keys + %w(odania-core odania-varnish)
		@main_modules_pre = Hashie::Mash.new({
															 'core' => {
																 prepare: [
																	 'rake odania:register',
																	 'rake elasticsearch:indices'
																 ]
															 }
														 })


		@main_modules_post = Hashie::Mash.new({
															  'core' => {
																  prepare: [
																	  'rake odania:global:generate_config'
																  ]
															  },
															  'varnish' => {
																  prepare: [
																	  'rake varnish:generate'
																  ]
															  }
														  })

		@instances_per_module = get_instances_per_module
	end

	def wait_for_consul_join
		consul_nodes = @instances_per_module['consul']
		$logger.info "Waiting for consul to join. Nodes: #{consul_nodes.join(', ')}"

		consul_joined = false
		while !consul_joined
			consul_joined = true

			consul_nodes.each do |node|
				consul_joined = false unless system "docker exec -t #{node} ping consul -c 1"
			end

			unless consul_joined
				print '.'
				sleep 1
			end
		end
		puts
	end

	def prepare
		module_docker_names = []

		$logger.info 'Executing modules prepare STEP: pre'
		process_cmds @instances_per_module, @main_modules_pre
		$logger.info 'Executing modules prepare STEP: modules'
		process_cmds @instances_per_module, @modules
		$logger.info 'Executing modules prepare STEP: post'
		process_cmds @instances_per_module, @main_modules_post

		module_docker_names
	end

	private

	def process_cmds(instances_per_module, modules)
		modules.each do |name, data|
			unless data.prepare.nil?
				$logger.info "Preparing #{name} Instances: #{instances_per_module[name].join(', ')}"
				data.prepare.each do |cmd|
					execute_command_on_instances instances_per_module[name], cmd
				end
			end
		end
	end

	def execute_command_on_instances(instances, cmd)
		instances.each do |instance|
			execute_and_show_cmd "docker exec -t #{instance} #{cmd}"
		end
	end

	def get_instances_per_module
		instances = Hash.new { |hash, key| hash[key] = [] }
		`docker-compose ps`.split("\n").each do |line|
			parts = line.split(' ')
			name = parts[0]
			name_parts = name.split('_')
			if 3.eql? name_parts.length
				instances[name_parts[1]] << name
			end
		end
		instances
	end
end
