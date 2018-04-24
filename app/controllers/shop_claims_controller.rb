class ShopClaimsController < ApplicationController
  include Filterize
  filterize order: :updated_at_desc, param: :f
  before_filter :authenticate_admin!
  before_action :filterize, only: :index
  before_action :set_shop_claim, only: [:show, :update, :destroy]
  before_action :set_shop_claims, only: [:update_many, :destroy_many]

  # GET /shop_claims
  # GET /shop_claims.json
  def index
    response.headers['X-Total-Count'] = @shop_claims.map.count.to_s
    @shop_claims = @shop_claims.page(params[:page]) if params[:page].present?
    @shop_claims = @shop_claims.per(params[:per]) if params[:per].present?

    _render collection: @shop_claims, flag: params[:flag].try(:to_sym)
  end

  # GET /shop_claims/1
  # GET /shop_claims/1.json
  def show
    _render member: @shop_claim, flag: :complete
  end

  # POST /shop_claims
  # POST /shop_claims.json
  def create
    @shop_claim = ShopClaim.new(shop_claim_params)

    if @shop_claim.save
      render json: @shop_claim, status: :created, location: @shop_claim
    else
      render json: @shop_claim.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shop_claims/1
  # PATCH/PUT /shop_claims/1.json
  def update
    @shop_claim = ShopClaim.find(params[:id])

    if @shop_claim.update(shop_claim_params)
      head :no_content
    else
      render json: @shop_claim.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shop_claims/1
  # DELETE /shop_claims/1.json
  def destroy
    @shop_claim.destroy

    head :no_content
  end
  
  # PATCH/PUT /shop_claims.json
  def update_many
    if @shop_claims.update_all(shop_claim_params)
      render json: @shop_claims, status: :ok, location: shop_claims_url
    else
      render json: @shop_claims.map{ |shop_claim| shop_claim.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /shop_claims.json
  def destroy_many
    if (@shop_claims.destroy_all rescue false)
      head :no_content
    else
      render json: @shop_claims.map{ |shop_claim| shop_claim.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_shop_claim
      @shop_claim = ShopClaim.find(params[:id])
    end

    def set_shop_claims
      @shop_claims = ShopClaim.where(id: params[:ids])
    end

    def shop_claim_params
      params.permit(:status, :user_id, :shop_id)
    end
end
