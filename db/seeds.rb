# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Shed.create([
	{ title: 'Urkupiña' },
	{ title: 'Punta Mogote' },
	{ title: 'Los Coreanos' },
	{ title: 'Ocean' },
	{ title: 'Atlantida' },
	{ title: 'Galerias' }
])

Category.create([
	{ title: 'Ropa informal' },
	{ title: 'Calzado' },
	{ title: 'Accesorios' },
	{ title: 'Electrónica' },
	{ title: 'Articulos para el hogar' },
	{ title: 'Relojeria' }
])

Promotion.create([
	{ name: 'Towering', title: 'Vende más, anuncia en destacado', description: 'Recibe presencia en la página principal de Salada App, paga <b>$200.-</b>  por única vez, y obten una mejor ubicación en listados de producto.', price: 200.00, duration: 30 }
])