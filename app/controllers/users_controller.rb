class UsersController < ApplicationController
  include Filterize
  filterize param: :f
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_user, only: [:show, :cards, :update, :destroy]
  before_action :filterize, only: :index

  # GET /users
  # GET /users.json
  def index
    if params[:page].present?
      @users = @users.page(params[:page])
      @users = @users.per(params[:per]) if params[:per].present?
      response.headers["X-total"] = @users.total_count.to_s
      response.headers["X-offset"] = @users.offset_value.to_s
      response.headers["X-limit"] = @users.limit_value.to_s
    end

    if (JSON.parse(params[:f]).symbolize_keys[:select] == ['id', 'name'] rescue false)
      render json: @users, minimal: true
    elsif (JSON.parse(params[:f]).symbolize_keys[:select] == ['id', 'name', 'email', 'role'] rescue false)
      render json: @users, medium: true
    else
      render json: @users
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # GET /users/1/cards
  def cards
    render json: @user.cards
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user != current_user
      render json: ['Not authorized for that action'], status: :forbidden
    elsif @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user != current_user
      render json: ['Not authorized for that action'], status: :forbidden
    else
      @user.destroy
      head :no_content
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :email, :gender, :birthday, :id_type, :id_number, :locality, :address, :phone_number, :role)
    end
end
