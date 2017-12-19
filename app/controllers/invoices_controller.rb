class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all

    render json: @invoices
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    render json: @invoice
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      render json: @invoice, status: :created, location: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    if @invoice.update(invoice_params)
      head :no_content
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy

    head :no_content
  end

  private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.permit(:mercadopago_invoice_id, :mercadopago_subscription_id, :mercadopago_plan_id, :subscription, :plan, :user, :payer, :application_fee, :status, :description, :metadata, :payments, :debit_date, :next_payment_attempt, :mercadopago_invoice)
    end
end
