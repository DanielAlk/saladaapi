class PushJob
  include SuckerPunch::Job
  include IonicApi

  def perform(request_body)
  	request_body[:profile] = ionic_push_profile
  	ionic_api :push, :post, request_body, :notifications
  end
end