class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments.json
  def index
    @payments = current_user.payments.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 12)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.permit(:user_id, :payable_id, :payable_type, :promotionable_id, :promotionable_type, :kind, :transaction_amount, :installments, :payment_method_id, :token, :mercadopago_payment, :mercadopago_payment_id, :status, :status_detail, :save_address, :save_card)
    end
end