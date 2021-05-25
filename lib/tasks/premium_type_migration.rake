namespace :premium_type_migration do
	desc 'Maintenance tasks'

	task script: :environment do
		plan_group_description = PlanGroup.find(2).description

		# set all existing premium users to shedsalers

		User.where(special: User.specials[:premium]).where(premium_type: User.premium_types[:freesaler]).update_all(premium_type: User.premium_types[:shedsaler])

		# create seller plans (existing premium GroupPlans are updated to shedsalers)

		PlanGroup.update_all(premium_type: PlanGroup.premium_types[:shedsaler])
		wholesaler_plan = PlanGroup.create(name: 'wholesaler_cash', title: 'Pack Mayorista Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:seller], premium_type: PlanGroup.premium_types[:wholesaler])
		fairsaler_plan = PlanGroup.create(name: 'fairsaler_cash', title: 'Pack Feriante Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:seller], premium_type: PlanGroup.premium_types[:fairsaler])
		
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly wholesaler package')
		Plan.create(plan_group: wholesaler_plan, name: 'wholesaler_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly wholesaler package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly fairsaler package')
		Plan.create(plan_group: fairsaler_plan, name: 'fairsaler_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly fairsaler package')
		
		# create provider plans
		
		wholesaler_provider_plan = PlanGroup.create(name: 'wholesaler_provider_cash', title: 'Pack Mayorista Proveedor Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:provider], premium_type: PlanGroup.premium_types[:wholesaler])
		fairsaler_provider_plan = PlanGroup.create(name: 'fairsaler_provider_cash', title: 'Pack Feriante Proveedor Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:provider], premium_type: PlanGroup.premium_types[:fairsaler])
		premium_provider_plan = PlanGroup.create(name: 'premium_provider_cash', title: 'Pack Premium Proveedor Contado', description: plan_group_description, kind: PlanGroup.kinds[:cash], subscriptable_role: User.roles[:provider], premium_type: PlanGroup.premium_types[:shedsaler])
		
		Plan.create(plan_group: wholesaler_provider_plan, name: 'wholesaler_provider_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly wholesaler provider package')
		Plan.create(plan_group: wholesaler_provider_plan, name: 'wholesaler_provider_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly wholesaler provider package')
		Plan.create(plan_group: fairsaler_provider_plan, name: 'fairsaler_provider_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly fairsaler provider package')
		Plan.create(plan_group: fairsaler_provider_plan, name: 'fairsaler_provider_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly fairsaler provider package')
		Plan.create(plan_group: premium_provider_plan, name: 'premium_provider_cash_monthly', title: 'Mensual', kind: Plan.kinds[:cash], price: 199.99, frequency: 1, frequency_type: Plan.frequency_types[:months], description: 'Monthly premium provider package')
		Plan.create(plan_group: premium_provider_plan, name: 'premium_provider_cash_yearly', title: 'Anual', kind: Plan.kinds[:cash], price: 1999.99, frequency: 12, frequency_type: Plan.frequency_types[:months], description: 'Yearly premium provider package')
	end
end
