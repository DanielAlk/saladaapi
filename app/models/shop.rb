class Shop < ActiveRecord::Base
	has_attached_file :image, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }
	validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
  belongs_to :user
  belongs_to :shed
  belongs_to :category

  enum location: [ :aisle, :line, :side, :other ]
  enum status: [ :occupied, :empty, :repairs ]

end
