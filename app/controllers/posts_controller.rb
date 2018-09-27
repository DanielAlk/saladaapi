class PostsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f, scope: :active, scope_if: :is_client_app?
  before_filter :authenticate_admin!, except: [:index, :show]
  before_action :filterize, only: :index
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :set_posts, only: [:update_many, :destroy_many]

  # GET /posts
  # GET /posts.json
  def index
    response.headers['X-Total-Count'] = @posts.count.to_s
    @posts = @posts.page(params[:page]) if params[:page].present?
    @posts = @posts.per(params[:per]) if params[:per].present?

    render json: @posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy

    head :no_content
  end
  
  # PATCH/PUT /posts.json
  def update_many
    if @posts.update_all(post_params)
      render json: @posts, status: :ok, location: posts_url
    else
      render json: @posts.map{ |post| post.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /posts.json
  def destroy_many
    if (@posts.destroy_all rescue false)
      head :no_content
    else
      render json: @posts.map{ |post| post.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def set_posts
      @posts = Post.where(id: params[:ids])
    end

    def post_params
      params.permit(:title, :subtitle, :text, :cover, :status)
    end
end
