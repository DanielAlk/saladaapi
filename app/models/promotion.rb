class Promotion < ActiveRecord::Base
	enum kind: [ :debit, :cash ]
	enum duration_type: [ :days, :months ]

	def to_hash(flag = nil)
		promotion = JSON.parse(self.to_json).deep_symbolize_keys
	end
end
