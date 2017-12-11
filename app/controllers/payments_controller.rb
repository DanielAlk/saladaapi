class PaymentsController < ApplicationController
  include MercadoPagoHelper
  skip_before_action :verify_authenticity_token, only: :notifications
  before_action :authenticate_user!, except: :notifications
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments.json
  def index
    # if admin_signed_in?
    #   @payments = @payments.paginate(:page => params[:page], :per_page => 12)
    # else
      @payments = current_user.payments.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 12)
    # end
    render json: @payments
  end

  # GET /payments/1.json
  def show
    if @payment.user != current_user
      raise ActionController::RoutingError.new("No route matches [GET] \"#{request.path}\"")
    else
      render json: @payment
    end
  end

  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      # Notifier.notify_admin(@payment).deliver_later
      # Notifier.notify_user(@payment).deliver_later
      render json: @payment, status: :created, location: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    if @payment.update(payment_params)
      render :show, status: :ok, location: @payment
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
    if @payment.present?
      # Notifier.notify_admin(@payment, 'mercadopago_notification').deliver_later
      # Notifier.notify_user(@payment, 'mercadopago_notification').deliver_later
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
      params.permit(:user_id, :payable_id, :payable_type, :transaction_amount, :installments, :payment_method_id, :token, :mercadopago_payment, :mercadopago_payment_id, :status, :status_detail, :save_address, :save_card)
    end
end