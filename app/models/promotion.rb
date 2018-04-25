class Promotion < ActiveRecord::Base
	enum kind: [ :debit, :cash ]
	enum duration_type: [ :days, :months ]

	validates :title, presence: true, length: { minimum: 4, maximum: 50 }
	validates :description, presence: true, length: { minimum: 6, maximum: 280 }
	validates :price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }
	validates :duration, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999 }

	def to_hash(flag = nil)
		promotion = JSON.parse(self.to_json).deep_symbolize_keys
	end
end
