class ProductsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_action :filterize, only: :index
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    render json: @products
  end

  # GET /products/1
  # GET /products/1.json
  def show
    render json: @product
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      head :no_content
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy

    head :no_content
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.permit(:user_id, :category_id, :shop_id, :title, :stock, :price, :description)
    end
end
