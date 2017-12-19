module MercadoPagoConcern
	extend ActiveSupport::Concern

	def mercadopago_message
		if self.failed? && self.mercadopago_payment.present? && mercadopago_errors.keys.include?(self.mercadopago_payment[:status].try(:to_i))
			message = mercadopago_errors[self.mercadopago_payment[:status].try(:to_i)]
		elsif self.status.present? && self.status_detail.present?
			message = mercadopago_messages[self.status.to_sym][self.status_detail.to_sym]
		else
			message = 'Ocurrió un error al procesar tu pago, por favor intenta nuevamente en unos minutos.'
		end
		message.gsub(/\{\{\w+\}\}/) do |match|
			self.mercadopago_payment[match.gsub(/[{}]/, '').try(:to_sym)].to_s
		end
	end

	private
		def mercadopago_messages
			{
			  approved: { 
			    accredited: '¡Listo, se acreditó tu pago!<br>En tu resumen verás el cargo de {{transaction_amount}} como {{statement_descriptor}}.'
			  },
			  in_process: {
			    pending_contingency: 'Estamos procesando el pago.<br>En menos de una hora te enviaremos por e-mail el resultado.',
			    pending_review_manual: 'Estamos procesando el pago.<br>En menos de 2 días hábiles te diremos por e-mail si se acreditó o si necesitamos más información.'
			  },
			  rejected: {
			    cc_rejected_bad_filled_card_number: 'Revisa el número de tarjeta.',
			    cc_rejected_bad_filled_date: 'Revisa la fecha de vencimiento.',
			    cc_rejected_bad_filled_other: 'Revisa los datos.',
			    cc_rejected_bad_filled_security_code: 'Revisa el código de seguridad.',
			    cc_rejected_blacklist: 'No pudimos procesar tu pago.',
			    cc_rejected_call_for_authorize: 'Debes autorizar ante {{payment_method_id}} el pago de {{transaction_amount}} a MercadoPago',
			    cc_rejected_card_disabled: 'Llama a {{payment_method_id}} para que active tu tarjeta.<br>El teléfono está al dorso de tu tarjeta.',
			    cc_rejected_card_error: 'No pudimos procesar tu pago.',
			    cc_rejected_duplicated_payment: 'Ya hiciste un pago por ese valor.<br>Si necesitas volver a pagar usa otra tarjeta u otro medio de pago.',
			    cc_rejected_high_risk: 'Tu pago fue rechazado.<br>Elige otro de los medios de pago, te recomendamos con medios en efectivo.',
			    cc_rejected_insufficient_amount: 'Tu {{payment_method_id}} no tiene fondos suficientes.',
			    cc_rejected_invalid_installments: '{{payment_method_id}} no procesa pagos en {{installments}} cuotas.',
			    cc_rejected_max_attempts: 'Llegaste al límite de intentos permitidos.<br>Elige otra tarjeta u otro medio de pago.',
			    cc_rejected_other_reason: '{{payment_method_id}} no procesó el pago.'
			  }
			}
		end

		def mercadopago_errors
			{
			  106 => {
			    description: 'Cannot operate between users from different countries',
			    message: 'No puedes realizar pagos a usuarios de otros países.'
			  },
			  109 => {
			    description: 'Invalid number of shares for this payment_method_id',
			    message: '{{payment_method_id}} no procesa pagos en {{installments}} cuotas. Elige otra tarjeta u otro medio de pago.'
			  },
			  126 => {
			    description: 'The action requested is not valid for the current payment state',
			    message: 'No pudimos procesar tu pago.'
			  },
			  129 => {
			    description: 'Cannot pay this amount with this paymentMethod',
			    message: '{{payment_method_id}} no procesa pagos del monto seleccionado. Elige otra tarjeta u otro medio de pago.'
			  },
			  145 => {
			    description: 'Invalid users involved',
			    message: 'No pudimos procesar tu pago.'
			  },
			  150 => {
			    description: 'The payer_id cannot do payments currently',
			    message: 'No puedes realizar pagos.'
			  },
			  151 => {
			    description: 'The payer_id cannot do payments with this payment_method_id',
			    message: 'No puedes realizar pagos.'
			  },
			  160 => {
			    description: 'Collector not allowed to operate',
			    message: 'No pudimos procesar tu pago.'
			  },
			  204 => {
			    description: 'Unavailable paymentmethod',
			    message: '{{payment_method_id}} no está disponible en este momento. Elige otra tarjeta u otro medio de pago.'
			  },
			  801 => {
			    description: 'Already posted the same request in the last minute',
			    message: 'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos.'
			  }
			}
		end
end