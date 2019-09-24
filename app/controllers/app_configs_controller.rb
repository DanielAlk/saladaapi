class AppConfigsController < ApplicationController
  before_filter :authenticate_admin!
  before_action :set_app_config, only: [:show, :update, :destroy]

  # GET /app_configs
  # GET /app_configs.json
  def index
    @app_configs = AppConfig.all

    render json: @app_configs
  end

  # GET /app_configs/1
  # GET /app_configs/1.json
  def show
    render json: @app_config
  end

  # POST /app_configs
  # POST /app_configs.json
  def create
    @app_config = AppConfig.new(app_config_params)

    if @app_config.save
      render json: @app_config, status: :created, location: @app_config
    else
      render json: @app_config.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /app_configs/1
  # PATCH/PUT /app_configs/1.json
  def update
    @app_config = AppConfig.find(params[:id])

    if @app_config.update(app_config_params)
      head :no_content
    else
      render json: @app_config.errors, status: :unprocessable_entity
    end
  end

  # DELETE /app_configs/1
  # DELETE /app_configs/1.json
  def destroy
    @app_config.destroy

    head :no_content
  end

  private

    def set_app_config
      @app_config = AppConfig.find(params[:id])
    end

    def app_config_params
      params.permit(:sid, :title, :content)
    end
end
