class Product < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :category
  belongs_to :shop
  has_many :images, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

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

  def unanswered_comments_count
    self.comments.unanswered.count
  end

  def cover
  	self.images.try(:first).try(:url)
  end
end
