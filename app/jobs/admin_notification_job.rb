class AdminNotificationJob
  include SuckerPunch::Job
  
  def perform(notification)
    AdminNotification.create(notification)
  end
end
