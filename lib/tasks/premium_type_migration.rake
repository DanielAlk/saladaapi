namespace :premium_type_migration do
	desc 'Maintenance tasks'

	task script: :environment do
		plan_group_description = PlanGroup.find(2).description
		PlanGroup.update_all(premium_type: 3)
		wholesaler_plan = PlanGroup.create(name: 'wholesaler_cash', title: 'Pack Mayorista Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:seller], starting_price: 199.99, premium_type: 1)
		fairsaler_plan = PlanGroup.create(name: 'fairsaler_cash', title: 'Pack Feriante Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:seller], starting_price: 199.99, premium_type: 2)
		
		PlanGroup.where(starting_price: nil).update_all(starting_price: 199.99)
		
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly wholesaler package')
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly wholesaler package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly fairsaler package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly fairsaler package')

		User.where(special: User.specials[:premium]).where(premium_type: 0).update_all(premium_type: User.premium_types[:shedsaler])
	end

	task script_providers: :environment do
		plan_group_description = PlanGroup.find(2).description
		
		wholesaler_plan = PlanGroup.create(name: 'wholesaler_provider_cash', title: 'Pack Mayorista Proveedor Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:provider], starting_price: 199.99, premium_type: 1)
		fairsaler_plan = PlanGroup.create(name: 'fairsaler_provider_cash', title: 'Pack Feriante Proveedor Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:provider], starting_price: 199.99, premium_type: 2)
		premium_plan = PlanGroup.create(name: 'premium_provider_cash', title: 'Pack Premium Proveedor Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:provider], starting_price: 199.99, premium_type: 3)
		
		PlanGroup.where(starting_price: nil).update_all(starting_price: 199.99)
		
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_provider_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly wholesaler provider package')
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_provider_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly wholesaler provider package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_provider_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly fairsaler provider package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_provider_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly fairsaler provider package')
		Plan.create(plan_group: premium_plan, name: 'premium_provider_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly premium provider package')
		Plan.create(plan_group: premium_plan, name: 'premium_provider_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly premium provider package')
	end
end
