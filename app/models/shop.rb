class Shop < ActiveRecord::Base
	include Filterable
	has_attached_file :image, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }, default_url: lambda { |a| "#{a.instance.image_default_url}" }
	validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
  belongs_to :user
  belongs_to :shed
  belongs_to :category
  has_many :products, dependent: :destroy
  has_many :shop_claims, dependent: :destroy, autosave: true

  validates :description, presence: true, length: { minimum: 4, maximum: 50 }, unless: :created_by_user?
  validates :category, :fixed, :opens, :condition, presence: true, unless: :created_by_user?
  validates :user, :shed, :number_id, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999.999999999 }
  validates :longitude, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999.999999999 }
  validate :user_limit

  filterable scopes: [ :status ]
  filterable search: [ :description, :number_id ]
  filterable order: [ :category, :shed, :user ]
  filterable labels: {
    order: {
      status: 'status', category: 'categoría', shed: 'galpón'
    },
    scopes: {
      condition: { occupied: 'ocupado', empty: 'vacío', repairs: 'en reparación' }
    }
  }

  enum status: [ :draft, :published, :paused, :created_by_user ]
  enum location: [ :aisle, :side ]
  enum condition: [ :occupied, :empty, :repairs ]

  scope :claimable, -> { not_created_by_user.where(user_id: User.admin.map{|u| u.id}) }
  scope :not_created_by_user, -> { where.not(status: Shop.statuses[:created_by_user]) }
  scope :owned_by_premium, -> { where(user_id: User.premium.select(:id).map{ |u| u.id }) }

  before_validation :set_status
  before_update :assign_products_to_user, if: :user_id_changed?
  before_update :inherit_created_by_user_shop_products, if: :user_id_changed?
  before_destroy :destroy_shop_claims

  def claimant_id=(claimant_id)
    claimant = User.find(claimant_id)
    self.shop_claims.new(user: claimant)
  end

  def cover
    if self.image.present?
      {
        blank: self.image.blank?,
        thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:thumb),
        small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:small),
        medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:medium),
        original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:original)
      }
    else
      {
        blank: self.image.blank?,
        thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image_default_url(:thumb),
        small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image_default_url(:small),
        medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image_default_url(:medium),
        original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image_default_url(:original)
      }
    end
  end

  def shed_title
    self.shed.title
  end

  def image_default_url(style = nil)
    unless style.present?
      ActionController::Base.helpers.asset_url("missing.png", :digest => false)
    else
      ActionController::Base.helpers.asset_url("missing-#{style.to_s}.jpg", :digest => false)
    end
  end

  def is_claimable?
    self.user.admin?
  end

  def to_hash(flag = nil)
    shop = JSON.parse(self.to_json).deep_symbolize_keys
    shop[:cover] = self.cover
    shop[:user_name] = self.user.name
    shop[:shed_title] = self.shed_title
    shop[:category_title] = (self.category.title rescue nil)
    if flag == :complete
      shop[:user] = self.user.to_hash
      shop[:category] = self.category
      shop[:shed] = self.shed
      shop[:products] = {
        items: self.products.order(special: :desc).page(1).per(4).map{ |product| product.to_hash },
        total_count: self.products.count
      }
      shop[:shop_claims] = {
        items: self.shop_claims.order(updated_at: :desc).page(1).per(4).map{ |shop_claim| shop_claim.to_hash(:complete) },
        total_count: self.shop_claims.count
      }
    end
    shop
  end

  private
    def destroy_shop_claims
      self.shop_claims.delete_all
    end

    def assign_products_to_user
      self.products.find_each{ |p| p.update(user_id: self.user_id) }
    end

    def inherit_created_by_user_shop_products
      if self.user.shops.created_by_user.count > 0
        self.user.shops.created_by_user.first.products.each do |product|
          product.shop = self
          product.save
        end
      end
    end

    def set_status
      self.status = :created_by_user if self.new_record? && !self.user.admin?
    end

    def user_limit
      errors.add(:user_limit, "Not allowed") if self.new_record? && self.user.shop_limit != :unlimited && self.user.shops.not_created_by_user.count >= self.user.shop_limit
    end
end
