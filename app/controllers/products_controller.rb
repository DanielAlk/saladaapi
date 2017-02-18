class ProductsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authenticate_user!, only: :index, if: -> { params[:interaction].present? }
  before_action :filterize, only: :index, unless: -> { params[:interaction].present? }
  before_action :set_interaction_products, only: :index, if: -> { params[:interaction].present? }
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    response.headers['X-Total-Count'] = @products.count.to_s
    @products = @products.page(params[:page]) if params[:page].present?
    @products = @products.per(params[:per]) if params[:per].present?
    render json: @products, interaction: serializer_interaction
  end

  # GET /products/1
  # GET /products/1.json
  def show
    render json: @product, complete: true
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

    def interaction_params
      JSON.parse(params[:interaction]).try(:symbolize_keys)
    end

    def serializer_interaction
      if params[:interaction].present?
        if interaction_params[:user].present?
          :user
        elsif interaction_params[:owner].present?
          :owner
        end
      end
    end

    def set_interaction_products
      if interaction_params[:user].present?
        where_clause = 'interactions.user_id'
        user_id = interaction_params[:user]
      end
      if interaction_params[:owner].present?
        where_clause = 'interactions.owner_id'
        user_id = interaction_params[:owner]
      end
      @products = Product.distinct.joins(:interactions).where(where_clause => user_id).order('interactions.last_comment_created_at DESC')
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.permit(:user_id, :category_id, :shop_id, :title, :stock, :price, :description, :status, :special)
    end
end
