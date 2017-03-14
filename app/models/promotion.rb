class Promotion < ActiveRecord::Base
	enum duration_type: [ :days, :months ]
end
