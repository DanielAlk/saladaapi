class ShopsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_action :filterize, only: :index
  #before_filter :authenticate_user!, except: [:index, :show]
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
    if user_signed_in? && current_user == @shop.user
      render json: @shop, owner: true
    else
      render json: @shop, complete: true
    end
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)
    #@shop.user = current_user

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
    #if @shop.user != current_user
    #  render json: ['Unable to update shop'], status: :unauthorized
    if @shop.update(shop_params)
      head :no_content
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    #if @shop.user == current_user
      @shop.destroy
      head :no_content
    #else
    #  render json: ['Unable to delete shop'], status: :unauthorized
    #end
  end

  private

    def set_shop
      @shop = Shop.find(params[:id])
    end

    def shop_params
      if (params[:image].to_s.start_with?('/system') rescue false) || (params[:image].to_s.start_with?('/assets') rescue false)
        params.permit(:user_id, :shed_id, :category_id, :description, :location, :location_detail, :location_floor, :location_row, :gallery_name, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating)
      else
        params.permit(:user_id, :shed_id, :category_id, :description, :location, :location_detail, :location_floor, :location_row, :gallery_name, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating, :image, :image_file_name)
      end
    end
end
