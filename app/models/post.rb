class Post < ActiveRecord::Base
	include Filterable
	has_attached_file :cover, styles: { large: "825x370#", medium: "710x318#", small: "297x257#", thumb: "127x127#" }, default_url: lambda { |a| "#{a.instance.cover_default_url}" }
	validates_attachment :cover, content_type: { content_type: /\Aimage\/.*\Z/ }

	validates :video_id, length: { minimum: 6, maximum: 20 }, allow_blank: true

	filterable search: [:title, :text]
	filterable scopes: [:status]

	enum status: [ :active, :paused ]

	def cover_url
		{
			thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:thumb),
			small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:small),
			medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:medium),
			large: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:large),
			original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.cover.url(:original),
		}
	end

	def cover_default_url
    ActionController::Base.helpers.asset_url("missing.png", :digest => false)
  end
end
