class CommentsController < ApplicationController
  include Filterize
  before_filter :authenticate_user!, except: [:index, :show]
  filterize order: :created_at_desc, param: :f
  before_action :filterize, only: :index
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    response.headers['X-Total-Count'] = @comments.count.to_s
    @comments = @comments.page(params[:page]) if params[:page].present?
    @comments = @comments.per(params[:per_page]) if params[:per_page].present?
    render json: @comments
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    render json: @comment, complete: true
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      head :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update_many
    @comments = Comment.where(id: params[:ids])

    if @comments.update_all(comment_params)
      head :no_content
    else
      render json: ['Unable to update comments'], status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if @comment.commentable.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: ['Unable to delete comment'], status: :forbidden
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.permit(:title, :text, :commentable_id, :commentable_type, :read)
    end
end
