module OneSignal
	extend ActiveSupport::Concern

	def create_notification(params)
		params[:app_id] = ENV['onesignal_app_id']

		api_request :notifications, :post, params
  end

  private
  	def api_request(resource, method, params = {})
  		begin
  			uri = URI.parse('https://onesignal.com/api/v1/' + resource.to_s)

  			request = Net::HTTP.class_eval(method.to_s.titleize).new(uri.path)
  			request.body = params.to_json
  			request['Content-Type'] = 'application/json'
  			request['Authorization'] = 'Basic ' + ENV['onesignal_api_key']

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
end