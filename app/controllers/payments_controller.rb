class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :notifications
  #before_action :authenticate_user!, except: :notifications
  #before_action :authenticate_admin!, only: :edit
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_payment_user!, only: [:show, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    #if current_user.admin?
    #  @payments = Payment.order(updated_at: :desc).paginate(page: params[:page], per_page: 12)
    #else
      @payments = Payment.order(updated_at: :desc).where(user: current_user).page(params[:page])
    #end
    render json: @payments
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    render json: @payment
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      render json: @payment, status: :created, location: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    payment_from_mp = Payment.find_mp(payment_params[:collection_id])
    if payment_from_mp.present? && payment_from_mp == @payment
      @payment = payment_from_mp
    elsif payment_params[:collection_id].present? && @payment.collection_status.nil?
      @payment.collection_status = 'in_process'
    end

    if @payment.save
      #Notifier.notify_admin(@payment).deliver_later
      #Notifier.notify_user(@payment).deliver_later
      render json: @payment, status: :ok, location: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy

    head :no_content
  end

  # POST /payments/notifications/
  def notifications
    topic = params[:type] || params[:topic]
    if topic.try(:to_sym) == :payment
      id = params['data.id'] || params[:id]
      @payment = Payment.find_mp(id)
    end
    if @payment.present? && @payment.save
      #Notifier.notify_admin(@payment, 'notification').deliver_later
      #Notifier.notify_user(@payment, 'notification').deliver_later
      render json: @payment, status: :ok
    else
      head :no_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      #params.permit(:user_id, :payable_id, :payable_type, :transaction_amount, :collection_id, :collection_status, :collection_status_detail, :preference_id, :payment_type)
      params.permit(:user_id, :payable_id, :payable_type, :collection_id)
    end

    def authenticate_payment_user!
      unless @payment.user == current_user
        raise ActionController::RoutingError.new("No route matches [GET] \"#{request.path}\"")
      end
    end
end
