Rails.application.routes.default_url_options = {
    host: ENV["webapp_domain"],
    protocol: ENV["webapp_protocol"]
}