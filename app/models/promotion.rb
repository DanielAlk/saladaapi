class Promotion < ActiveRecord::Base
	enum kind: [ :debit, :cash ]
	enum duration_type: [ :days, :months ]
end
