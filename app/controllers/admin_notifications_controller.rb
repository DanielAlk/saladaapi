class AdminNotificationsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_filter :authenticate_admin!
  before_action :filterize, only: :index
  before_action :set_admin_notification, only: [:show, :update, :destroy]
  before_action :set_admin_notifications, only: [:update_many, :destroy_many]

  # GET /admin_notifications
  # GET /admin_notifications.json
  def index    
    response.headers['X-Total-Count'] = @admin_notifications.count.to_s
    response.headers['X-Unread-Count'] = @admin_notifications.unread.count.to_s
    @admin_notifications = @admin_notifications.page(params[:page] || 1)
    @admin_notifications = @admin_notifications.per(params[:per] || 8)
    
    _render collection: @admin_notifications
  end

  # GET /admin_notifications/1
  # GET /admin_notifications/1.json
  def show
    _render member: @admin_notification
  end

  # POST /admin_notifications
  # POST /admin_notifications.json
  def create
    @admin_notification = AdminNotification.new(admin_notification_params)

    if @admin_notification.save
      render json: @admin_notification, status: :created, location: @admin_notification
    else
      render json: @admin_notification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin_notifications/1
  # PATCH/PUT /admin_notifications/1.json
  def update
    @admin_notification = AdminNotification.find(params[:id])

    if @admin_notification.update(admin_notification_params)
      head :no_content
    else
      render json: @admin_notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admin_notifications/1
  # DELETE /admin_notifications/1.json
  def destroy
    @admin_notification.destroy

    head :no_content
  end
  
  # PATCH/PUT /admin_notifications
  # PATCH/PUT /admin_notifications.json
  def update_many
    if @admin_notifications.update_all(admin_notification_params)
      render json: @admin_notifications, status: :ok, location: admin_notifications_url
    else
      render json: @admin_notifications.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admin_notifications.json
  def destroy_many
    if (@admin_notifications.destroy_all rescue false)
      head :no_content
    else
      render json: @admin_notifications.errors, status: :unprocessable_entity
    end
  end

  private

    def set_admin_notification
      @admin_notification = AdminNotification.find(params[:id])
    end

    def set_admin_notifications
      @admin_notifications = AdminNotification.where(id: params[:ids])
    end

    def admin_notification_params
      params.permit(:kind, :alertable_id, :alertable_type, :metadata, :status)
    end
end
