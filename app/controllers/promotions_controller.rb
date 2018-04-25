class PromotionsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index, :show]
  before_action :set_promotion, only: [:show, :update, :destroy]

  # GET /promotions
  # GET /promotions.json
  def index
    if params[:product_id]
      @promotions = Product.find(params[:product_id]).promotions
    else
      @promotions = Promotion.all
    end

    render json: @promotions
  end

  # GET /promotions/1
  # GET /promotions/1.json
  def show
    render json: @promotion
  end

  # POST /promotions
  # POST /promotions.json
  def create
    @promotion = Promotion.new(promotion_params)

    if @promotion.save
      render json: @promotion, status: :created, location: @promotion
    else
      render json: @promotion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /promotions/1
  # PATCH/PUT /promotions/1.json
  def update
    @promotion = Promotion.find(params[:id])

    if @promotion.update(promotion_params)
      head :no_content
    else
      render json: @promotion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /promotions/1
  # DELETE /promotions/1.json
  def destroy
    @promotion.destroy

    head :no_content
  end

  private

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params.permit(:name, :title, :kind, :description, :price, :duration, :duration_type)
    end
end
