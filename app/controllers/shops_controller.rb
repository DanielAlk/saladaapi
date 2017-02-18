class ShopsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_action :filterize, only: :index
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_shop, only: [:show, :update, :destroy]

  # GET /shops
  # GET /shops.json
  def index
    response.headers['X-Total-Count'] = @shops.count.to_s
    @shops = @shops.page(params[:page]) if params[:page].present?
    render json: @shops
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    render json: @shop, complete: true
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)
    @shop.user = current_user

    if @shop.save
      render json: @shop, status: :created, location: @shop
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    @shop = Shop.find(params[:id])
    if @shop.user == current_user && @shop.update(shop_params)
      head :no_content
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy if @shop.user == current_user

    head :no_content
  end

  private

    def set_shop
      @shop = Shop.find(params[:id])
    end

    def shop_params
      params.permit(:user_id, :shed_id, :category_id, :description, :location, :location_detail, :between_down, :between_up, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating, :image)
    end
end
