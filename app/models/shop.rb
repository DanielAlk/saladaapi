class Shop < ActiveRecord::Base
	include Filterable
	has_attached_file :image, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }, default_url: '/assets/missing.png'
	validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
  belongs_to :user
  belongs_to :shed
  belongs_to :category
  has_many :products, dependent: :destroy

  filterable scopes: [ :status ]
  filterable search: [ :description ]
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
  enum location: [ :aisle, :line, :side, :other ]
  enum condition: [ :occupied, :empty, :repairs ]

  def cover
    {
      thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:thumb),
      small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:small),
      medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.image.url(:medium)
    }
  end

  def shed_title
    self.shed.title
  end

end
