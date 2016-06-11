class DockerComposeTemplate
	attr_reader :modules

	def initialize(modules)
		@modules = modules
		@template = File.read File.join BASE_DIR, 'config', 'docker-compose.yml.erb'
	end

	def render
		Erubis::Eruby.new(@template).result(binding)
	end

	def write(out_dir)
		File.write("#{out_dir}/docker-compose.yml", self.render)
	end
end

