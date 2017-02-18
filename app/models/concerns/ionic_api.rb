module IonicApi
	extend ActiveSupport::Concern

	def ionic_api(resource, method, data = {}, path_params = false)
		begin
			uri = URI.parse(ENV['ionic_api_url'])
			path = path_params.present? ? "/#{resource.to_s}/#{path_params.to_s}" : "/#{resource.to_s}"
			request = Net::HTTP.class_eval(method.to_s.titleize).new(path)
			request.body = data.to_json
			request['Content-Type'] = 'application/json'
			request['Authorization'] = 'Bearer ' + ENV['ionic_api_token']
			response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
			  http.request(request)
			end
			if response.is_a?(Net::HTTPSuccess) && response.try(:body).present?
				JSON.parse(response.body.to_s)
			else
				false
			end
		rescue StandardError
			false
		end
	end

	def ionic_app_id
		ENV['ionic_app_id']
	end

	def ionic_push_profile
		ENV['ionic_push_profile']
	end
end