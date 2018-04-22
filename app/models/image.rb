class Image < ActiveRecord::Base
	has_attached_file :item, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }
	#validates_attachment :item, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { less_than: 1.megabytes }
	validates_attachment :item, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }
	belongs_to :imageable, polymorphic: true
	acts_as_list scope: :imageable

	before_destroy :check_product_images

	def url
		{
			thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.item.url(:thumb),
			small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.item.url(:small),
			medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.item.url(:medium),
			original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.item.url(:original),
		}
	end

	def to_hash
		image = JSON.parse(self.to_json).deep_symbolize_keys
		image[:url] = self.url
		image
	end

	private
		def check_product_images
			if self.imageable_type == 'Product' && self.imageable.images.count == 1
				self.imageable.draft!
			end
		end
end
