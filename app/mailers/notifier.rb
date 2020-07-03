class Notifier < ApplicationMailer
  def contact(object)
    mail(to: admin_email, body: contact_body(object), content_type: "text/html", subject: "Nuevo contacto SaladaApp")
  end

  private
  	def admin_email
  		ENV['notifications_mailer_to']
  	end

  	def contact_body(object)
  		body = '<h1>SaladaApp</h1>'
  		body += '<h2>Contacto</h2>'
  		body += '<p>'
  		body += '<strong>Nombre:</strong> ' + object.name.to_s + '<br>'
  		body += '<strong>Email:</strong> ' + object.email.to_s + '<br>'
  		body += '<strong>Telefono:</strong> ' + object.tel.to_s + '<br>'
  		body += '<strong>Tipo:</strong> ' + ({ seller: 'Comerciante', client: 'Visitante', provider: 'Proveedor' }[object.role.try(:to_sym)] || object.role.to_s) + '<br>'
  		body += '<strong>Mensaje:</strong> ' + object.message.to_s
  		body += '</p>'
  		body
  	end
end