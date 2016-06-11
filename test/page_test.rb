class PageTest < TestBase
	def initialize(varnish_ips, sites)
		super varnish_ips
		@sites = sites
	end

	def check
		$logger.info "Checking sites #{@sites.count}"
		errors = Hash.new { |hash, key| hash[key] = Hash.new { |h, k| h[k] = [] } }
		error_cnt = 0
		@sites.each_pair do |host, data|
			data.pages.each do |url|
				request_url = "http://#{host}#{url}"

				result, varnish_compare_errors = retrieve_page request_url
				$logger.info "Page #{request_url} Reponse Code: #{result.code} Header: #{result.header.inspect} Location: #{result.header['location'].inspect}"

				if result.code < 200 or result.code > 299
					errors[host]['Invalid response code'] << build_error(host, url, result.code)
					error_cnt += 1
				end

				varnish_compare_errors.each do |error|
					errors['varnish error'] << error
					error_cnt += 1
				end

			end
		end

		if error_cnt == 0
			$logger.info 'No page errors found'
		else
			$logger.error "Found #{error_cnt} page errors"
		end

		errors
	end

	private

	def build_error(host, url, response_code)
		res = "   - Host: #{host} Url: #{url} Code: #{response_code}"
		res
	end
end
