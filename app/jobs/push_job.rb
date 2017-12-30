class PushJob
  include SuckerPunch::Job
  include OneSignal

  def perform(contents)
  	params = {
  		filters: [
  			{ field: 'tag', key: 'id', relation: '=', value: contents[:user_id] }
  		],
  		contents: { en: contents[:message], es: contents[:message] },
  		headings: { en: contents[:title], es: contents[:title] },
  		content_available: true,
  		data: contents[:data],
  		ios_badgeType: 'SetTo',
  		ios_badgeCount: contents[:badge_number]
  	}

  	if contents[:buttons].present?
  		params[:buttons] = []
  		contents[:buttons].each_with_index do |text, index|
  			params[:buttons] << { id: index.to_s, text: text }
  		end
  	end

  	create_notification params
  end
end