class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :create_ionic_user_if_not_created, if: :login_action?

  respond_to :json

  protected

  	def configure_permitted_parameters
  		key_array = [:name, :nickname, :image, :role, :io_uid, :id_type, :id_number, :gender, :birthday, :phone_number, :address, :locality, :metadata, :avatar]
  		devise_parameter_sanitizer.permit(:sign_up, keys: key_array)
  		devise_parameter_sanitizer.permit(:account_update, keys: key_array)
  	end

  	def login_action?
  		controller_name == 'sessions' && action_name == 'create'
  	end

  	def create_ionic_user_if_not_created
      if !!current_user && current_user.valid_password?(params[:password])
  		  unless current_user.io_uid?
  		  	if (user = User.find_by(email: params[:email])).present?
  		  		unless user.io_uid?
  		  			user.ionic_create(params[:password])
  		  			user.save
	  	  		end
	  	  	end
  		  end
      end
  	end

end
