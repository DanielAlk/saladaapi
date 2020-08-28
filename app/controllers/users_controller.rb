class UsersController < ApplicationController
  include Filterize
  filterize param: :f
  before_filter :authenticate_admin!, if: :is_client_panel?
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :filterize, only: :index
  before_action :set_user, only: [:show, :cards, :update, :destroy]
  before_action :set_users, only: [:update_many, :destroy_many]

  # GET /users
  # GET /users.json
  def index
    if params[:page].present?
      response.headers['X-Total-Count'] = @users.count.to_s
      @users = @users.page(params[:page])
      @users = @users.per(params[:per]) if params[:per].present?
    end

    _render collection: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    _render member: @user, flag: :complete
  end

  # GET /users/1/cards
  def cards
    render json: @user.cards
  end

  # POST /users/push
  def push
    push_params = params.permit(:title, :message)
    PushJob.perform_async({
      title: push_params[:title],
      message: push_params[:message]
    })
    head :no_content
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
    if current_user.admin? && params[:password].present?
      @user.password = params[:password]
    end
    if @user != current_user && !current_user.admin?
      render json: ['Not authorized for that action'], status: :unauthorized
    elsif @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user != current_user && !current_user.admin?
      render json: ['Not authorized for that action'], status: :unauthorized
    else
      if @user.destroy
        head :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end
  
  # PATCH/PUT /users
  # PATCH/PUT /users.json
  def update_many
    if @users.update_all(user_params)
      render json: @users, status: :ok, location: users_url
    else
      render json: @users.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users.json
  def destroy_many
    if (@users.destroy_all rescue false)
      head :no_content
    else
      render json: @users.errors, status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def set_users
      @users = User.where(id: params[:ids])
    end

    def user_params
      params.permit(:name, :email, :gender, :birthday, :id_type, :id_number, :locality, :address, :phone_number, :phone_numbers_limit, :role, :avatar, :push)
    end
end
