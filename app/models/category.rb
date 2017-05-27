class Category < ActiveRecord::Base
	include Filterable
	has_ancestry

	filterable search: [:title]
end
