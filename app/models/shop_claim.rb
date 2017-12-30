class ShopClaim < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop

  validates_uniqueness_of :user, scope: :shop, message: 'Ya reclamaste este puesto'
  validate :user_can_claim?, on: :create

  enum status: [ :in_review, :approved, :denied, :deleted ]

  after_save :approve_claim, if: :approved_and_status_changed?
  after_save :push_notificate, if: :status_changed?, unless: :deleted?

  def destroy
  	if self.denied? && self.shop.user.admin?
  		self.deleted!
  	else
  		super
  	end
  end

  private
    def push_notificate
      self.user.increment!(:badge_number)
      contents = {
        user_id: self.user.id,
        title: 'Puesto ' + self.shop.number_id.to_s + ' - ' + self.shop.shed.title,
        message: push_message,
        data: {
          state: 'app.shop_claims'
        },
        badge_number: self.user.badge_number,
        buttons: [ 'Ver' ]
      }
      PushJob.perform_async(contents)
    end

    def push_message
      {
        in_review: 'Tu reclamo está siendo revisado',
        approved: 'Tu reclamo fue aprobado',
        denied: 'Tu reclamo fue denegado'
      }[self.status.try(:to_sym)]
    end

    def user_can_claim?
      unless user.shop_limit == :unlimited
        statuses = self.class.statuses.map{|k,s| s if [:in_review, :approved].include?(k.to_sym) }.compact
        unless user.shop_limit > user.shop_claims.where(status: [statuses]).count
          errors.add(:shop_limit, 'Como usuario free no podés reclamar más de 1 puesto a la vez.')
        end
      end
    end

    def approve_claim
  		shop_claims = self.shop.shop_claims.where.not(id: self.id)
  		shop_claims.deleted.delete_all
  		shop_claims.in_review.update_all(status: self.class.statuses[:denied])
  		self.shop.update(user_id: self.user_id)
  	end

  	def approved_and_status_changed?
  		self.status_changed? && self.approved?
  	end
end
