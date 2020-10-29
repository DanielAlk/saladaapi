class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_rescue
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  respond_to :json

  def record_not_found_rescue(exception)
    logger.info("#{exception.class}: " + exception.message)
    if Rails.env.production?
      render json: { status: 'not found', message: exception.to_s }, status: :not_found
    else
      render json: { status: 'not found', message: exception.to_s, backtrace: exception.backtrace }, status: :not_found
    end
  end

  def routing_error(error = 'Routing error', status = :not_found, exception=nil)
    render json: { status: 'not found', message: 'Not found' }, status: :not_found
  end

  protected

  	def configure_permitted_parameters
  		key_array = [:name, :nickname, :image, :badge_number, :role, :special, :io_uid, :id_type, :id_number, :gender, :birthday, :phone_number, :address, :locality, :metadata, :avatar, :id_image]
  		devise_parameter_sanitizer.permit(:sign_up, keys: key_array)
  		devise_parameter_sanitizer.permit(:account_update, keys: key_array)
  	end

  	def login_action?
  		controller_name == 'sessions' && action_name == 'create'
  	end

    def authenticate_admin!
      unless (current_user.admin? rescue false)
        return render json: {
          errors: ["Authorized users only."]
        }, status: 401
      end
    end

    def _render(options, render_options = {})
      object = options[:collection] || options[:member]
      if is_client_panel?
        response.headers['Content-Type'] = 'application/json'
        if options[:collection] != nil
          render body: object.map{ |member| member.to_hash(options[:flag]) }.to_json
        else
          render body: object.to_hash(options[:flag]).to_json
        end
      else
        render({ json: object }.merge(render_options))
      end
    end

    def is_client_panel?
      request.headers['Client-App'] == 'SaladaPanel'
    end

    def is_client_app?
      !is_client_panel?
    end

end
