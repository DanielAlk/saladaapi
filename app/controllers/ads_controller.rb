class AdsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :update]
  before_action :set_ad, only: [:show, :update, :destroy]

  # GET /ads
  # GET /ads.json
  def index
    @ads = Ad.limit(2).order("RAND()")

    render json: @ads
  end

  # GET /ads/1
  # GET /ads/1.json
  def show
    render json: @ad
  end

  # POST /ads
  # POST /ads.json
  def create
    @ad = Ad.new(ad_params)

    if @ad.save
      render json: @ad, status: :created, location: @ad
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ads/1
  # PATCH/PUT /ads/1.json
  def update
    @ad = Ad.find(params[:id])

    if @ad.update(ad_params)
      head :no_content
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ads/1
  # DELETE /ads/1.json
  def destroy
    @ad.destroy

    head :no_content
  end

  private

    def set_ad
      @ad = Ad.find(params[:id])
    end

    def ad_params
      params.permit(:title, :text, :actions, :cover, :special, :status, :kind)
    end
end
