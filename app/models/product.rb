class Product < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :category
  belongs_to :shop
  has_many :images, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :interactions, dependent: :destroy
  has_many :payments, as: :promotionable
  has_many :reviews, dependent: :destroy

  validates :title, presence: true, length: { minimum: 4, maximum: 50 }
  validates :description, presence: true, length: { minimum: 6, maximum: 280 }
  validates :video_id, length: { minimum: 6, maximum: 20 }, allow_blank: true
  validates :user, :category, presence: true
  validates :shop, presence: true, unless: :is_provider_user?
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_blank: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999 }
  validates :wholesaler_amount, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999 }, allow_blank: true
  validates :shipping_amount, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999 }, allow_blank: true
  validates :price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }
  validates :retailer_price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }, if: :is_retailer
  validates :shipping_price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }, allow_blank: true
  validate :validate_status, on: :update, if: :status_changed?
  validate :user_limit
  validate :image_limit

  after_destroy :disassociate_payments
  before_create :set_provider_product
  before_update :assign_interactions_to_user, if: :user_id_changed?
  before_save :disassociate_not_matching_payments, if: :special_changed?
  after_update :destroy_created_by_user_shop, if: :shop_id_changed?
  after_save :update_shop_product_count, if: :shop_id_changed?

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

  scope :owned_by_premium, -> { where(user_id: User.premium.select(:id).map{ |u| u.id }) }

  def comments_count
    self.comments.count
  end

  def cover
    if images.present?
      self.images.try(:first).try(:url)
    else
      rtn = {}
      [:thumb, :small, :medium, :original].each do |key|
        rtn[key] = ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + ActionController::Base.helpers.asset_url("missing-#{key}.jpg", :digest => false)
      end
      rtn
    end
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

  def to_hash(flag = nil)
    product = JSON.parse(self.to_json).deep_symbolize_keys
    product[:category_title] = (self.category.title rescue nil)
    product[:user_name] = self.user.name
    product[:shop_description] = (self.shop.description rescue nil)
    product[:shop_created_by_user] = (self.shop.created_by_user? rescue nil)
    product[:cover] = self.cover

    if flag == :complete
      product[:user] = self.user.to_hash
      product[:shop] = self.shop
      product[:category] = self.category
      product[:images] = self.images.map{ |image| image.to_hash }
      product[:image_limit] = self.user.product_image_limit
      product[:promotions] = self.promotions
      product[:payments] = {
        items: self.payments.order(updated_at: :desc).page(1).per(4).map{ |payment| payment.to_hash },
        total_count: self.payments.count
      }
      product[:comments] = {
        items: self.comments.order(created_at: :desc).page(1).per(4).map{ |comment| comment.to_hash(:complete) },
        total_count: self.comments.count
      }
      product[:reviews] = {
        items: self.reviews.order(created_at: :desc).page(1).per(4).map{ |review| review.to_hash(:complete) },
        total_count: self.reviews.count
      }
    end
    product
  end

  private
    def disassociate_not_matching_payments
      payments.each do |payment|
        if payment.payable.name.try(:to_sym) != self.special.try(:to_sym)
          unless [:in_mediation, :in_process, :pending, :authorized].include?(payment.status.try(:to_sym))
            payment.promotionable = nil
            payment.save
          end
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

    def destroy_created_by_user_shop
      previous_shop = Shop.find(self.shop_id_was)
      if previous_shop.created_by_user? && previous_shop.products.count == 0
        previous_shop.destroy
      end
    end

    def update_shop_product_count
      self.shop.update(product_count: self.shop.products.count) if self.shop.present?
      if self.shop_id_changed? && self.shop_id_was.present?
        previous_shop = Shop.find(self.shop_id_was) rescue false
        previous_shop.update(product_count: previous_shop.products.count) if previous_shop.present?
      end
    end

    def validate_status
      unless draft? || images.present?
        errors.add(:status_error, "No se puede cambiar el estado de un producto sin imágenes")
      end
    end

    def user_limit
      errors.add(:user_limit, "Not allowed") if self.new_record? && self.user.present? && self.user.product_limit != :unlimited && self.user.products.count >= self.user.product_limit
    end

    def image_limit
      if self.images.size > self.user.product_image_limit
        errors.add(:image_limit, "El usuario ha alcanzado su limite de imágenes en este producto")
      end
    end

    def set_provider_product
      self.provider_product = is_provider_user?
      return
    end

    def is_provider_user?
      self.user.provider?
    end
end
