class PaymentsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_action :authenticate_admin!, only: [:update, :destroy]
  before_action :authenticate_user!
  before_action :filterize, only: :index
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments.json
  def index
    response.headers['X-Total-Count'] = @payments.count.to_s
    @payments = @payments.page(params[:page]) if params[:page].present?
    @payments = @payments.per(params[:per]) if params[:per].present?

    _render collection: @payments, flag: params[:flag].try(:to_sym)
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
    if @payment.update(params.permit(:status))
      head :no_content
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    if @payment.destroy
      head :no_content
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.permit(:user_id, :payable_id, :payable_type, :promotionable_id, :promotionable_type, :kind, :transaction_amount, :installments, :payment_method_id, :token, :mercadopago_payment, :mercadopago_payment_id, :save_address, :save_card)
    end
end