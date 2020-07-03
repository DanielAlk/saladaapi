class Category < ActiveRecord::Base
	include Filterable
	has_ancestry

	has_many :shops
	has_many :products

	validates :title, uniqueness: true

	filterable search: [:title]

	enum user_role: [ :seller, :provider, :all_roles ]

	scope :for_sellers, -> { where(user_role: Category.user_roles.select{ |r| r.to_sym != :provider }.map{ |r| r[1] }) }
	scope :for_providers, -> { where(user_role: Category.user_roles.select{ |r| r.to_sym != :seller }.map{ |r| r[1] }) }

	before_destroy :disassociate_shops_and_products

	private

		def disassociate_shops_and_products
			self.shops.update_all(category_id: nil)
			self.products.update_all(category_id: nil)
		end
end
