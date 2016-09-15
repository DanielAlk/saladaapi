class ShedsController < ApplicationController
  before_action :set_shed, only: [:show, :update, :destroy]

  # GET /sheds
  # GET /sheds.json
  def index
    @sheds = Shed.all

    render json: @sheds
  end

  # GET /sheds/1
  # GET /sheds/1.json
  def show
    render json: @shed
  end

  # POST /sheds
  # POST /sheds.json
  def create
    @shed = Shed.new(shed_params)

    if @shed.save
      render json: @shed, status: :created, location: @shed
    else
      render json: @shed.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sheds/1
  # PATCH/PUT /sheds/1.json
  def update
    @shed = Shed.find(params[:id])

    if @shed.update(shed_params)
      head :no_content
    else
      render json: @shed.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sheds/1
  # DELETE /sheds/1.json
  def destroy
    @shed.destroy

    head :no_content
  end

  private

    def set_shed
      @shed = Shed.find(params[:id])
    end

    def shed_params
      params.require(:shed).permit(:title)
    end
end
