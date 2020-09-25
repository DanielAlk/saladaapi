class AdminNotification < ActiveRecord::Base
  include Filterable
  belongs_to :alertable, polymorphic: true
  
  serialize :metadata

  enum kind: [ :undefined, :user_product_limit ]
  enum status: [ :unread, :read, :deleted ]

  def to_hash(flag = nil)
    admin_notification = JSON.parse(self.to_json).deep_symbolize_keys
    admin_notification[:alertable] = self.alertable.to_hash
    admin_notification
  end
end
