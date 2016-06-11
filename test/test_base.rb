class TestBase
	def initialize(varnish_ips)
		@varnish_ips = varnish_ips
	end

	protected

	def retrieve_page(url, check_equal=true)
		responses = []
		errors = []

		@varnish_ips.each_with_index do |varnish_ip, idx|
			options =  {http_proxyaddr: varnish_ip, http_proxyport: 80, follow_redirects: false}
			responses[idx] = HTTParty.get url, options
		end

		first_response = responses.first

		if check_equal
			responses.each do |response|
				unless first_response.code.eql? response.code
					errors << "Response code from varnish is not equal! response code: #{first_response.code} Other Response code: #{response.code}"
					$logger.error 'Response code from varnish is not equal!'
				end
			end
		end

		return first_response, errors
	end
end
