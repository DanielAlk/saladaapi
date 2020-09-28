class AdminNotificationJob
  include SuckerPunch::Job
  
  def perform(notification)
    ActiveRecord::Base.connection_pool.with_connection do
      AdminNotification.create(notification)
    end
  end
end
