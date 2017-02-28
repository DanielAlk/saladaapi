class Product < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :category
  belongs_to :shop
  has_many :images, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :interactions, dependent: :destroy

  validates :title, presence: true, length: { minimum: 4, maximum: 50 }
  validates :description, presence: true, length: { minimum: 6, maximum: 140 }
  validates :user, :category, :shop, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999 }
  validates :price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }

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
end
