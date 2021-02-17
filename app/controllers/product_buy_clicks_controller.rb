class ProductBuyClicksController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_admin!, except: [:create]
  before_action :filterize, only: :index
  before_action :set_product_buy_click, only: [:show, :update, :destroy]
  before_action :set_product_buy_clicks, only: [:update_many, :destroy_many]

  # GET /product_buy_clicks
  # GET /product_buy_clicks.json
  def index
    response.headers['X-Total-Count'] = @product_buy_clicks.count.to_s
    @product_buy_clicks = @product_buy_clicks.page(params[:page] || 1)
    @product_buy_clicks = @product_buy_clicks.per(params[:per] || 8)
    
    render json: @product_buy_clicks
  end

  # GET /product_buy_clicks/1
  # GET /product_buy_clicks/1.json
  def show
    render json: @product_buy_click
  end

  # POST /product_buy_clicks
  # POST /product_buy_clicks.json
  def create
    @product_buy_click = ProductBuyClick.new(product_buy_click_params)
    @product_buy_click.user = current_user if is_client_app?

    if @product_buy_click.save
      render json: @product_buy_click, status: :created, location: @product_buy_click
    else
      render json: @product_buy_click.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_buy_clicks/1
  # PATCH/PUT /product_buy_clicks/1.json
  def update
    @product_buy_click = ProductBuyClick.find(params[:id])

    if @product_buy_click.update(product_buy_click_params)
      head :no_content
    else
      render json: @product_buy_click.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_buy_clicks/1
  # DELETE /product_buy_clicks/1.json
  def destroy
    @product_buy_click.destroy

    head :no_content
  end

  # PATCH/PUT /product_buy_clicks
  # PATCH/PUT /product_buy_clicks.json
  def update_many
    if @product_buy_clicks.update_all(product_buy_click_params)
      render json: @product_buy_clicks, status: :ok, location: product_buy_clicks_url
    else
      render json: @product_buy_clicks.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_buy_clicks.json
  def destroy_many
    if (@product_buy_clicks.destroy_all rescue false)
      head :no_content
    else
      render json: @product_buy_clicks.errors, status: :unprocessable_entity
    end
  end

  private

    def set_product_buy_click
      @product_buy_click = ProductBuyClick.find(params[:id])
    end

    def set_product_buy_clicks
      @product_buy_clicks = ProductBuyClick.where(id: params[:ids])
    end

    def product_buy_click_params
      params.permit(:user_id, :product_id)
    end
end
