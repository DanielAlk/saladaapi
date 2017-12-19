class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_subscription, only: [:show, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    if params[:user_id].present?
      t = Subscription.arel_table
      s = Subscription.statuses
      @subscriptions = Subscription.where(user_id: params[:user_id]).where(t[:status].eq(s[:authorized]).or(t[:status].eq(s[:paused])))
    else
      @subscriptions = Subscription.all
    end

    render json: @subscriptions
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    render json: @subscription
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      render json: @subscription, status: :created, location: @subscription
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    if @subscription.update(subscription_params)
      head :no_content
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy

    head :no_content
  end

  private

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def subscription_params
      params.permit(:mercadopago_subscription_id, :mercadopago_plan_id, :plan_id, :user_id, :kind, :payer, :payment_method_id, :next_payment_date, :token, :application_fee, :status, :description, :start_date, :end_date, :metadata, :charges_detail, :setup_fee, :mercadopago_subscription)
    end
end
