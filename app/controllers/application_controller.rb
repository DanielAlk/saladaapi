class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  protected

  	def configure_permitted_parameters
  		key_array = [:name, :nickname, :image, :role, :io_uid, :id_type, :id_number, :gender, :birthday, :phone_number, :address, :locality, :metadata, :avatar]
  		devise_parameter_sanitizer.permit(:sign_up, keys: key_array)
  		devise_parameter_sanitizer.permit(:account_update, keys: key_array)
  	end

end
