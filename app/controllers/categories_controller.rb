class CategoriesController < ApplicationController
  include Filterize
  filterize order: :title_asc, param: :f
  before_filter :authenticate_admin!, except: [:index, :show]
  before_action :filterize, only: :index
  before_action :set_category, only: [:show, :update, :destroy, :assign_to_shops, :assign_to_products]
  before_action :set_categories, only: [:update_many, :destroy_many]

  # GET /categories
  # GET /categories.json
  def index
    response.headers['X-Total-Count'] = @categories.count.to_s
    if params[:page].present?
      @categories = @categories.page(params[:page])
      @categories = @categories.per(params[:per]) if params[:per].present?
      response.headers["X-total"] = @categories.total_count.to_s
      response.headers["X-offset"] = @categories.offset_value.to_s
      response.headers["X-limit"] = @categories.limit_value.to_s
    end
    render json: @categories
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    render json: @category
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      head :no_content
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    if @category.destroy
      head :no_content
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /categories
  # PATCH/PUT /categories.json
  def update_many
    if @categories.update_all(category_params)
      render json: @categories, status: :ok, location: categories_url
    else
      render json: @categories.map{ |category| category.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /categories.json
  def destroy_many
    if (@categories.destroy_all rescue false)
      head :no_content
    else
      render json: @categories.map{ |category| category.errors }, status: :unprocessable_entity
    end
  end

  # PUT /categories/1/assign_to_shops.json
  def assign_to_shops
    shops = Shop.where(category_id: nil)
    if (shops.present?)
      shops.update_all(category_id: @category.id)
    end
    _render collection: shops
  end

  # PUT /categories/1/assign_to_products.json
  def assign_to_products
    products = Product.where(category_id: nil)
    if (products.present?)
      products.update_all(category_id: @category.id)
    end
    _render collection: products
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def set_categories
      @categories = Category.where(id: params[:ids])
    end

    def category_params
      params.permit(:title, :ancestry)
    end
end
