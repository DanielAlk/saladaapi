class Shop < ActiveRecord::Base
	include Filterable
	has_attached_file :image, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }, default_url: lambda { |a| "#{a.instance.image_default_url}" }
	validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
  belongs_to :user
  belongs_to :shed
  belongs_to :category
  has_many :products, dependent: :destroy
  has_many :shop_claims, dependent: :destroy, autosave: true

  validates :description, presence: true, length: { minimum: 4, maximum: 50 }
  validates :user, :shed, :category, :number_id, :fixed, :opens, :condition, presence: true
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

  enum status: [ :draft, :published, :paused ]
  enum location: [ :aisle, :side ]
  enum condition: [ :occupied, :empty, :repairs ]

  scope :claimable, -> { where(user_id: User.admin.map{|u| u.id}) }

  before_update :assign_products_to_user, if: :user_id_changed?

  def claimant_id=(claimant_id)
    claimant = User.find(claimant_id)
    self.shop_claims.new(user: claimant)
  end

  def cover
    {
      blank: self.image.blank?,
      thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:thumb),
      small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:small),
      medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:medium),
      original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:original)
    }
  end

  def shed_title
    self.shed.title
  end

  def image_default_url
    ActionController::Base.helpers.asset_url("missing.png", :digest => false)
  end

  def is_claimable?
    self.user.admin?
  end

  private
    def assign_products_to_user
      self.products.find_each{ |p| p.update(user_id: self.user_id) }
    end

    def user_limit
      errors.add(:user_limit, "Not allowed") if self.new_record? && self.user.shop_limit != :unlimited && self.user.shops.count >= self.user.shop_limit
    end
end
