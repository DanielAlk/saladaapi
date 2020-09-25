class ProductsController < ApplicationController
  include Filterize
  filterize order: :special_desc, param: :f, scope: :published, scope_if: :not_current_user_scope
  before_filter :authenticate_admin!, if: :is_client_panel?
  before_filter :authenticate_user!, if: :should_authenticate_user?
  before_action :filterize, only: :index, unless: -> { params[:interaction].present? }
  before_action :set_interaction_products, only: :index, if: -> { params[:interaction].present? }
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :set_products, only: [:update_many, :destroy_many]

  # GET /products
  # GET /products.json
  def index
    if @products != nil
      response.headers['X-Total-Count'] = @products.map.count.to_s

      @products = @products.order(updated_at: :desc)
      @products = @products.page(params[:page]) if params[:page].present?
      @products = @products.per(params[:per]) if params[:per].present?

      _render({ collection: @products }, { interaction: serializer_interaction })
    else
      render json: { errors: ['Invalid parameters.'] }, status: :bad_request
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if is_client_panel?
      _render member: @product, flag: :complete
    elsif @product.published? || user_signed_in? && @product.user == current_user
      render json: @product, complete: true
    else
      raise ActiveRecord::RecordNotFound, "Couldn't find Product with 'id'=#{params[:id]}"
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user unless is_client_panel?

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

    if @product.user != current_user && !current_user.admin?
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
    if @product.user == current_user || is_client_panel?
      @product.destroy
      head :no_content
    else
      render json: ['Unable to delete product'], status: :unauthorized
    end
  end
  
  # PATCH/PUT /products
  # PATCH/PUT /products.json
  def update_many
    if @products.update_all(product_params)
      render json: @products, status: :ok, location: products_url
    else
      render json: @products.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products.json
  def destroy_many
    if (@products.destroy_all rescue false)
      head :no_content
    else
      render json: @products.errors, status: :unprocessable_entity
    end
  end

  private

    def should_authenticate_user?
      ![:index, :show].include?(action_name.to_sym) || params[:interaction].present? && action_name.to_sym == :index
    end

    def not_current_user_scope(f)
      if (current_user.admin? rescue false)
        false
      else
        current_user.id != f[:scopes][:user].to_i rescue true
      end
    end

    def interaction_params
      JSON.parse(params[:interaction]).try(:symbolize_keys) rescue {}
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

    def set_products
      @products = Product.where(id: params[:ids])
    end

    def product_params
      params.permit(:user_id, :category_id, :shop_id, :title, :stock, :price, :description, :status, :special, :is_retailer, :wholesaler_amount, :shipping_amount, :retailer_price, :shipping_price, :video_id, :available_at)
    end
end
