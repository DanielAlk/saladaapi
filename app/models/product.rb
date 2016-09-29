class Product < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :category
  belongs_to :shop
  has_many :images, -> { order(position: :asc) }, as: :imageable, dependent: :destroy

  filterable search: [ :title, :price, :description ]
  filterable order: [ :category, :price, :user, :shop ]
  filterable labels: {
    order: {
      category: 'categoría', price: 'precio', user: 'usuario', shop: 'puesto'
    }
  }

  def cover
  	self.images.try(:first).try(:url)
  end
end
