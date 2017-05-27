class CategoriesController < ApplicationController
  include Filterize
  filterize order: :title_asc, param: :f
  before_action :filterize, only: :index
  before_action :set_category, only: [:show, :update, :destroy]
  before_action :set_categories, only: [:update_many, :destroy_many]

  # GET /categories
  # GET /categories.json
  def index
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
    @category.destroy

    head :no_content
  end
  
  # PATCH/PUT /categories
  # PATCH/PUT /categories.json
  def update_many
    if @categories.update_all(category_params)
      render json: @categories, status: :ok, location: categories_url
    else
      render json: @categories.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories.json
  def destroy_many
    if (@categories.destroy_all rescue false)
      head :no_content
    else
      render json: @categories.errors, status: :unprocessable_entity
    end
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
