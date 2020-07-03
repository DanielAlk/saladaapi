class ReviewsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_action :filterize, only: :index
  before_filter :authenticate_admin!, if: :is_client_panel?
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :set_reviews, only: [:update_many, :destroy_many]

  # GET /reviews
  # GET /reviews.json
  def index
    response.headers['X-Total-Count'] = @reviews.count.to_s
    @reviews = @reviews.page(params[:page]) if params[:page].present?
    @reviews = @reviews.per(params[:per]) if params[:per].present?

    _render collection: @reviews, flag: params[:flag].try(:to_sym)
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    render json: @review
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    if @review.save
      render json: @review, status: :created, location: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    @review = Review.find(params[:id])

    if @review.update(review_params)
      head :no_content
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy

    head :no_content
  end
  
  # PATCH/PUT /reviews.json
  def update_many
    if @reviews.update_all(review_params)
      render json: @reviews, status: :ok, location: reviews_url
    else
      render json: @reviews.map{ |review| review.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /reviews.json
  def destroy_many
    if (@reviews.destroy_all rescue false)
      head :no_content
    else
      render json: @reviews.map{ |review| review.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_review
      @review = Review.find(params[:id])
    end

    def set_reviews
      @reviews = Review.where(id: params[:ids])
    end

    def review_params
      params.permit(:user_id, :product_id, :text, :stars, :is_visible)
    end
end
