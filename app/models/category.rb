class Category < ActiveRecord::Base
	include Filterable
	has_ancestry

	has_many :shops
	has_many :products

	validates :title, uniqueness: true

	filterable search: [:title]

	before_destroy :disassociate_shops_and_products

	private

		def disassociate_shops_and_products
			self.shops.update_all(category_id: nil)
			self.products.update_all(category_id: nil)
		end
end
