class Review < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :product

  filterable search: [:text]
end
