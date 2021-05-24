namespace :premium_type_migration do
	desc 'Maintenance tasks'

	task script: :environment do
		plan_group_description = PlanGroup.find(2).description
		PlanGroup.update_all(premium_type: 3)
		wholesaler_plan = PlanGroup.create(name: 'wholesaler_cash', title: 'Pack Mayorista Contado', description: plan_group_description, kind: 1, subscriptable_role: 3, starting_price: 199.99, premium_type: 1)
		fairsaler_plan = PlanGroup.create(name: 'fairsaler_cash', title: 'Pack Feriante Contado', description: plan_group_description, kind: 1, subscriptable_role: 1, starting_price: 199.99, premium_type: 2)
		
		PlanGroup.where(starting_price: nil).update_all(starting_price: 199.99)
		
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_cash_monthly', title: 'Mensual', kind: 1, price: 199.99, frequency: 1, frequency_type: 1, description: 'Monthly wholesaler package')
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_cash_yearly', title: 'Anual', kind: 1, price: 1999.99, frequency: 12, frequency_type: 1, description: 'Yearly wholesaler package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_cash_monthly', title: 'Mensual', kind: 1, price: 199.99, frequency: 1, frequency_type: 1, description: 'Monthly fairsaler package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_cash_yearly', title: 'Anual', kind: 1, price: 1999.99, frequency: 12, frequency_type: 1, description: 'Yearly fairsaler package')

		User.where(special: User.specials[:premium]).where(premium_type: 0).update_all(premium_type: User.premium_types[:shedsaler])
	end
end
