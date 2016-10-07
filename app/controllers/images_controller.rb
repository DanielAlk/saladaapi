class ImagesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_image, only: [:show, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all

    render json: @images
  end

  # GET /images/1
  # GET /images/1.json
  def show
    render json: @image
  end

  # POST /images
  # POST /images.json
  def create
    if params[:images].present?
      images_params = params[:images].map { |k,i| { item: i[:item], imageable_id: i[:imageable_id], imageable_type: i[:imageable_type] } }
      images = Image.create(images_params)
      @invalid = []
      @images = []
      images.each do |image|
        if image.errors.count > 0
          @invalid << image.errors
        else
          @images << ActiveModelSerializers::SerializableResource.new(image)
        end
      end
      render json: { images: @images, invalid: @invalid }, status: :created
    else
      @image = Image.new(image_params)

      if @image.save
        render json: @image, status: :created, location: @image
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    @image = Image.find(params[:id])

    if @image.update(image_params)
      head :no_content
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy

    head :no_content
  end

  private

    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.permit(:title, :item, :imageable_id, :imageable_type, :position)
    end
end
