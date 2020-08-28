class UserPhoneNumbersController < ApplicationController
  include Filterize
  filterize param: :f
  before_filter :authenticate_admin!, if: :is_client_panel?
  before_filter :authenticate_user!
  before_action :filterize, only: :index
  before_action :set_user_phone_number, only: [:show, :update, :destroy]
  before_action :set_user_phone_numbers, only: [:update_many, :destroy_many]

  # GET /user_phone_numbers
  # GET /user_phone_numbers.json
  def index
    response.headers['X-Total-Count'] = @user_phone_numbers.count.to_s
    @user_phone_numbers = @user_phone_numbers.page(params[:page]) if params[:page].present?
    @user_phone_numbers = @user_phone_numbers.per(params[:per]) if params[:per].present?

    render json: @user_phone_numbers
  end

  # GET /user_phone_numbers/1
  # GET /user_phone_numbers/1.json
  def show
    render json: @user_phone_number
  end

  # POST /user_phone_numbers
  # POST /user_phone_numbers.json
  def create
    @user_phone_number = UserPhoneNumber.new(user_phone_number_params)
    @user_phone_number.user = current_user unless is_client_panel?

    if @user_phone_number.save
      render json: @user_phone_number, status: :created, location: @user_phone_number
    else
      render json: @user_phone_number.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_phone_numbers/1
  # PATCH/PUT /user_phone_numbers/1.json
  def update
    @user_phone_number = UserPhoneNumber.find(params[:id])
    if @user_phone_number.user != current_user && !current_user.admin?
      render json: ['Unable to update phone number'], status: :unauthorized
    elsif @user_phone_number.update(user_phone_number_params)
      head :no_content
    else
      render json: @user_phone_number.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_phone_numbers/1
  # DELETE /user_phone_numbers/1.json
  def destroy
    if @user_phone_number.user == current_user || is_client_panel?
      @user_phone_number.destroy
      head :no_content
    else
      render json: ['Unable to delete user_phone_number'], status: :unauthorized
    end
  end
  
  # PATCH/PUT /user_phone_numbers
  # PATCH/PUT /user_phone_numbers.json
  def update_many
    if @user_phone_numbers.update_all(user_phone_number_params)
      render json: @user_phone_numbers, status: :ok, location: user_phone_numbers_url
    else
      render json: @user_phone_numbers.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_phone_numbers.json
  def destroy_many
    if (@user_phone_numbers.destroy_all rescue false)
      head :no_content
    else
      render json: @user_phone_numbers.errors, status: :unprocessable_entity
    end
  end

  private

    def set_user_phone_number
      @user_phone_number = UserPhoneNumber.find(params[:id])
    end

    def set_user_phone_numbers
      @user_phone_numbers = UserPhoneNumber.where(id: params[:ids])
    end

    def user_phone_number_params
      params.permit(:user_id, :phone_number)
    end
end
