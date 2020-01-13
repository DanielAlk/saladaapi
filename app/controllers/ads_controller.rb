class AdsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_filter :authenticate_admin!, except: [:index, :show]
  before_action :filterize, only: :index, if: :is_client_panel?
  before_action :set_ad, only: [:show, :update, :destroy]
  before_action :set_ads, only: [:update_many, :destroy_many]

  # GET /ads
  # GET /ads.json
  def index
    if is_client_app?
      if params[:external].present?
        @ads = Ad.external.active.limit(params[:limit] || 1).order("RAND()")
      else
        @ads = Ad.announcement.active.limit(3).order("RAND()")
      end
    else
      response.headers['X-Total-Count'] = @ads.count.to_s
      @ads = @ads.page(params[:page]) if params[:page].present?
      @ads = @ads.per(params[:per]) if params[:per].present?
    end

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
  
  # PATCH/PUT /ads.json
  def update_many
    if @ads.update_all(ad_params)
      render json: @ads, status: :ok, location: ads_url
    else
      render json: @ads.map{ |ad| ad.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /ads.json
  def destroy_many
    if (@ads.destroy_all rescue false)
      head :no_content
    else
      render json: @ads.map{ |ad| ad.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_ad
      @ad = Ad.find(params[:id])
    end

    def set_ads
      @ads = Ad.where(id: params[:ids])
    end

    def ad_params
      params.permit(:title, :text, :actions, :cover, :special, :status, :kind)
    end
end
