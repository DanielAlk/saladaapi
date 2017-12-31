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
      first_image = params[:images].first[1]
      if first_image[:imageable_type] == 'Product'
        imageable = Product.find(first_image[:imageable_id])
      end
      if imageable.blank? || imageable.user != current_user
        return render json: ['You have no authorization for that action'], status: :unauthorized
      end
      images_params = params[:images].map { |k,i| { item: i[:item], imageable: imageable } }
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
      if image_params[:imageable_type] == 'Product'
        imageable = Product.find(image_params[:imageable_id])
      end
      if imageable.blank? || imageable.user != current_user
        return render json: ['You have no authorization for that action'], status: :unauthorized
      end
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
    if @image.imageable.user != current_user
      render json: ['You have no authorization for that action'], status: :unauthorized
    elsif @image.update(image_params)
      head :no_content
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    if @image.imageable.user != current_user
      render json: ['You have no authorization for that action'], status: :unauthorized
    else
      @image.destroy
      head :no_content
    end
  end

  private

    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.permit(:title, :item, :imageable_id, :imageable_type, :position)
    end
end
