class NotificationsController < ApplicationController
	skip_before_action :verify_authenticity_token

  # POST /notifications/mercadopago
  def mercadopago
    topic = params[:type] || params[:topic]
    mercadopago_id = params['data.id'] || params[:id]
    
    @record = Payment.find_mp(mercadopago_id) if topic.try(:to_sym) == :payment
    @record = Subscription.find_mp(mercadopago_id) if topic.try(:to_sym) == :subscription
    @record = Invoice.find_mp(mercadopago_id) if topic.try(:to_sym) == :invoice

    if @record.present?
      # Notifier.notify_admin(@payment, 'mercadopago_notification').deliver_later
      # Notifier.notify_user(@payment, 'mercadopago_notification').deliver_later
      render json: @record, status: :ok
    else
      head :no_content
    end
  end

end
