module OneSignal
	extend ActiveSupport::Concern

	def create_notification(params)
		params[:app_id] = ENV['onesignal_app_id']

		api_request :notifications, :post, params
  end

  private
    def prepare_params(params)
      environment_filter = { field: :tag, key: :environment, relation: "=", value: Rails.env }
      if params[:filters].present?
        params[:filters] << environment_filter
      else
        params[:filters] = [ environment_filter ]
      end
      params.to_json
    end

  	def api_request(resource, method, params = {})
  		begin
  			uri = URI.parse('https://onesignal.com/api/v1/' + resource.to_s)

  			request = Net::HTTP.class_eval(method.to_s.titleize).new(uri.path)
  			request.body = prepare_params(params)
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