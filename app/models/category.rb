class Category < ActiveRecord::Base
	include Filterable
	has_ancestry
end
