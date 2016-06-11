class RedirectTest < TestBase
	def initialize(varnish_ips, redirects)
		super varnish_ips
		@redirects = redirects
	end

	def check
		$logger.info "Checking redirects #{@redirects.count}"
		errors = Hash.new { |hash, key| hash[key] = [] }
		error_cnt = 0
		@redirects.each_pair do |from_url, target_url|
			result, varnish_compare_errors = retrieve_page "http://#{from_url}"
			$logger.info "Redirect #{from_url} Reponse Code: #{result.code}"
			location = result.header['location']

			if result.code < 300 or result.code > 399
				errors['Invalid response code'] << build_error(from_url, target_url, result.code)
				error_cnt += 1
			elsif !target_url.eql?(location)
				errors['Incorrect redirect'] << build_error(from_url, target_url, result.code, location)
				error_cnt += 1
			end

			varnish_compare_errors.each do |error|
				errors['varnish error'] << error
				error_cnt += 1
			end

		end

		if error_cnt == 0
			$logger.info 'No redirect errors found'
		else
			$logger.error "Found #{error_cnt} redirect errors"
		end

		errors
	end

	private

	def build_error(from_url, target_url, response_code, location=nil)
		res = " - From: #{from_url} To: #{target_url} Code: #{response_code}"
		res += " Location: #{location}" unless location.nil?
		res
	end
end
