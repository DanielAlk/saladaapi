class PushJob
  include SuckerPunch::Job
  include OneSignal

  def perform(contents)
  	params = {
  		contents: { en: contents[:message], es: contents[:message] },
  		headings: { en: contents[:title], es: contents[:title] },
  		content_available: true
    }

    if contents[:user_id].present?
      params[:filters] = [
        { field: :tag, key: :id, relation: '=', value: contents[:user_id] }
      ]
    end

    if contents[:role].present?
      params[:filters] = [
        { field: :tag, key: :role, relation: '=', value: contents[:role] }
      ]
    end

    params[:url] = contents[:url] if contents[:url].present?
  	params[:data] = contents[:data] if contents[:data].present?

    if contents[:badge_number].present?
      params[:ios_badgeType] = :SetTo;
      params[:ios_badgeCount] = contents[:badge_number];
    end

  	if contents[:buttons].present?
  		params[:buttons] = []
  		contents[:buttons].each_with_index do |text, index|
  			params[:buttons] << { id: index.to_s, text: text }
  		end
    end
    
  	create_notification params
  end
end