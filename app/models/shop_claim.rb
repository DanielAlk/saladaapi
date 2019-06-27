class ShopClaim < ActiveRecord::Base
  include Filterable
  belongs_to :user
  belongs_to :shop

  validates_uniqueness_of :user, scope: :shop, message: 'Ya reclamaste este puesto'
  validate :user_can_claim?, on: :create
  validate :is_shop_claimable?, on: :update, if: :in_review_and_was_denied?

  enum status: [ :in_review, :approved, :denied, :deleted ]
  enum state: [ :hidden, :visible ]

  before_save -> { self.state = ShopClaim.states[:visible] }, if: :in_review_and_was_approved?

  after_save :approve_claim, if: :approved_and_status_changed?
  after_save :revert_claim, if: :in_review_and_was_approved?
  after_save :push_notificate, if: :status_changed?, unless: :deleted?

  def destroy
  	if self.denied? && self.shop.user.admin?
  		self.deleted!
    elsif self.approved?
      self.hidden!
  	else
  		super
  	end
  end

  def to_hash(flag = nil)
    shop_claim = JSON.parse(self.to_json).deep_symbolize_keys
    shop_claim[:shop] = self.shop.to_hash
    if flag == :complete
      shop_claim[:user] = self.user.to_hash
    end
    shop_claim
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
        unless user.shop_limit > user.shop_claims.where(status: statuses).count + user.shops.not_created_by_user.count
          errors.add(:shop_limit, 'Como usuario free no podés reclamar más puestos.')
        end
      end
    end

    def is_shop_claimable?
      unless self.shop.is_claimable?
        errors.add(:shop_already_assigned, 'El puesto ya ha sido asignado a ' + self.shop.user.name + '.')
      end
    end

    def approve_claim
  		shop_claims = self.shop.shop_claims.where.not(id: self.id)
  		shop_claims.deleted.delete_all
  		shop_claims.in_review.update_all(status: self.class.statuses[:denied])
  		self.shop.update(user_id: self.user_id)
  	end

    def revert_claim
      if (admin = User.admin.first).present?
        self.shop.update(user_id: admin.id)
      end
    end

    def in_review_and_was_approved?
      self.status_changed? && self.in_review? && self.status_was.try(:to_sym) == :approved
    end

    def in_review_and_was_denied?
      self.status_changed? && self.in_review? && self.status_was.try(:to_sym) == :denied
    end

  	def approved_and_status_changed?
  		self.status_changed? && self.approved?
  	end
end
