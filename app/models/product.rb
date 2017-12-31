class Product < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :category
  belongs_to :shop
  has_many :images, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :interactions, dependent: :destroy
  has_many :payments, as: :promotionable

  validates :title, presence: true, length: { minimum: 4, maximum: 50 }
  validates :description, presence: true, length: { minimum: 6, maximum: 280 }
  validates :user, :category, :shop, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999 }
  validates :price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }
  validate :user_limit

  after_destroy :disassociate_payments
  before_update :assign_interactions_to_user, if: :user_id_changed?
  before_save :disassociate_not_matching_payments, if: :special_changed?

  filterable scopes: [ :status, :special ]
  filterable search: [ :title, :price, :description ]
  filterable order: [ :category, :price, :user, :shop ]
  filterable labels: {
    order: {
      category: 'categoría', price: 'precio', user: 'usuario', shop: 'puesto'
    }
  }

  enum status: [ :draft, :published, :paused, :in_review ]
  enum special: [ :standard, :salient, :important, :towering ]

  def comments_count
    self.comments.count
  end

  def cover
  	self.images.try(:first).try(:url)
  end

  def handle_payment(payment)
    if payment.approved?
      self.special = payment.payable.name
      self.save
    end
  end

  def promotions
    statuses = Payment.statuses.select do |s|
      [:in_mediation, :in_process, :authorized, :approved, :pending].include?(s.try(:to_sym))
    end.map{ |s,i| i }

    payments.where(status: statuses).map{ |payment| payment.payable }.uniq
  end

  private
    def disassociate_not_matching_payments
      payments.each do |payment|
        if payment.payable.name.try(:to_sym) != self.special.try(:to_sym)
          payment.promotionable = nil
          payment.save
        end
      end
    end

    def disassociate_payments
      payments.each do |payment|
        payment.promotionable = nil
        payment.save
      end
    end

    def assign_interactions_to_user
      self.interactions.find_each do |interaction|
        interaction.update(owner_id: self.user_id)
      end
    end

    def user_limit
      errors.add(:user_limit, "Not allowed") if self.new_record? && self.user.present? && self.user.product_limit != :unlimited && self.user.products.count >= self.user.product_limit
    end
end
