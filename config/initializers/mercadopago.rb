require 'mercadopago.rb'

$mp = MercadoPago.new(ENV['mercadopago_client_id'], ENV['mercadopago_client_secret'])

$mp.sandbox_mode(ENV['mercadopago_sandbox_mode'] == 'true')