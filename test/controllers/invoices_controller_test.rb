require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { application_fee: @invoice.application_fee, debit_date: @invoice.debit_date, description: @invoice.description, mercadopago_invoice: @invoice.mercadopago_invoice, mercadopago_invoice_id: @invoice.mercadopago_invoice_id, mercadopago_plan_id: @invoice.mercadopago_plan_id, mercadopago_subscription_id: @invoice.mercadopago_subscription_id, metadata: @invoice.metadata, next_payment_attempt: @invoice.next_payment_attempt, payer: @invoice.payer, payments: @invoice.payments, plan: @invoice.plan, status: @invoice.status, subscription: @invoice.subscription, user: @invoice.user }
    end

    assert_response 201
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    put :update, id: @invoice, invoice: { application_fee: @invoice.application_fee, debit_date: @invoice.debit_date, description: @invoice.description, mercadopago_invoice: @invoice.mercadopago_invoice, mercadopago_invoice_id: @invoice.mercadopago_invoice_id, mercadopago_plan_id: @invoice.mercadopago_plan_id, mercadopago_subscription_id: @invoice.mercadopago_subscription_id, metadata: @invoice.metadata, next_payment_attempt: @invoice.next_payment_attempt, payer: @invoice.payer, payments: @invoice.payments, plan: @invoice.plan, status: @invoice.status, subscription: @invoice.subscription, user: @invoice.user }
    assert_response 204
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_response 204
  end
end
