class Shop < ActiveRecord::Base
	include Filterable
	has_attached_file :image, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }, default_url: '/assets/missing.png'
	validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
  belongs_to :user
  belongs_to :shed
  belongs_to :category

  filterable scopes: [ :status ]
  filterable search: [ :description ]
  filterable order: [ :category, :shed, :user ]
  filterable labels: {
    order: {
      status: 'status', category: 'categoría', shed: 'galpón'
    },
    scopes: {
      status: { occupied: 'ocupado', empty: 'vacío', repairs: 'en reparación' }
    }
  }

  enum location: [ :aisle, :line, :side, :other ]
  enum status: [ :occupied, :empty, :repairs ]

  def cover
    ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:medium)
  end

  def cover_small
    ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:small)
  end

end
