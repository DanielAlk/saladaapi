class Ad < ActiveRecord::Base
	include Filterable
	has_attached_file :cover, styles: { medium: "640x300#", small: "297x257#", thumb: "127x127#" }, default_url: lambda { |a| "#{a.instance.cover_default_url}" }
	validates_attachment :cover, content_type: { content_type: /\Aimage\/.*\Z/ }

	filterable search: [:title, :text]

	enum status: [ :active, :paused ]
	enum special: [ :standard ]
	enum kind: [ :announcement, :external ]
	serialize :actions

	def actions=(data)
		if data.is_a? String
			self.actions = JSON.parse(data)
		else
			super
		end
	end

	def cover_url
		{
			thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:thumb),
			small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:small),
			medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:medium),
			original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:original),
		}
	end

	def cover_default_url
    ActionController::Base.helpers.asset_url("missing.png", :digest => false)
  end
end
