class ProductsController < ApplicationController
  include Filterize
  filterize order: :special_desc, param: :f, scope: :published, scope_if: :not_current_user_scope
  before_filter :authenticate_user!, except: [:index, :show], unless: -> { params[:interaction].present? }
  before_filter :authenticate_user!, only: :index, if: -> { params[:interaction].present? }
  before_action :filterize, only: :index, unless: -> { params[:interaction].present? }
  before_action :set_interaction_products, only: :index, if: -> { params[:interaction].present? }
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    response.headers['X-Total-Count'] = @products.map.count.to_s
    @products = @products.page(params[:page]) if params[:page].present?
    @products = @products.per(params[:per]) if params[:per].present?
    render json: @products, interaction: serializer_interaction
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if @product.published? || user_signed_in? && @product.user == current_user
      render json: @product, complete: true
    else
      render json: ['Product not found'], status: :not_found
    end
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

    if @product.user != current_user
      render json: ['Unable to update product'], status: :unauthorized
    elsif @product.update(product_params)
      head :no_content
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product.user == current_user
      @product.destroy
      head :no_content
    else
      render json: ['Unable to delete product'], status: :unauthorized
    end
  end

  private

    def not_current_user_scope(f)
      current_user.id != f[:scopes][:user].to_i rescue true
    end

    def interaction_params
      JSON.parse(params[:interaction]).try(:symbolize_keys)
    end

    def serializer_interaction
      if params[:interaction].present?
        if interaction_params[:user]
          :user
        elsif interaction_params[:owner]
          :owner
        end
      end
    end

    def set_interaction_products
      if interaction_params[:owner]
        @products = current_user.interacted_products_as(:owner)
      elsif interaction_params[:user]
        @products = current_user.interacted_products_as(:user)
      end
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.permit(:user_id, :category_id, :shop_id, :title, :stock, :price, :description, :status, :special)
    end
end
