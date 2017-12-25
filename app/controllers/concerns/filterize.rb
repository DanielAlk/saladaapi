module Filterize
	extend ActiveSupport::Concern

	module ClassMethods
	  attr_reader :filterize_options

	  private
		  def filterize(options={})
		  	if @filterize_options.blank?
		  		@filterize_options = options
		  	else
		  		@filterize_options = @filterize_options.merge(options)
		  	end
		  end
  end

	def filterize
		filterize_options = self.class.filterize_options
		@filterable = JSON.parse(params[filterize_options[:param] || :filterable]).try(:deep_symbolize_keys) rescue false
		object = filterize_options[:object].to_s.titlecase.constantize rescue false
		object = object || self.class.name.sub('Controller', '').singularize.constantize
		collection = object.where(nil)
		if @filterable.present?
			collection = collection.select(@filterable[:select]) if @filterable[:select].present?
			collection = collection.where(id: @filterable[:find]) if @filterable[:find].present?
			if @filterable[:scopes].present?
				@filterable[:scopes].keys.each do |key|
					if (scope = @filterable[:scopes][key]).present?
						if object.respond_to?(key.to_s) && scope === true #is scope
							collection = collection.send(key.to_s)
						elsif object.respond_to? key.to_s.pluralize #is enum
							if (scope.try(:length) > 1 rescue false)
								collection = collection.send(scope.to_s)
							else
								collection = collection.send(object.send(key.to_s.pluralize).key(scope.to_i))
							end
						elsif object.column_names.include?(key.to_s + '_id')
							collection = collection.where(key.to_s + '_id' => scope)
						else
							collection = collection.where(key => scope)
						end
					end
				end
			end
			collection = collection.fsearch @filterable[:search] if @filterable[:search].present?
			collection = collection.forder @filterable[:order] if @filterable[:order].present?
			collection = collection.joins(@filterable[:joins].to_sym).distinct if @filterable[:joins].present?
			if @filterable[:range].present?
				@filterable[:range].keys.each do |key|
					range = @filterable[:range][key]
					collection = collection.frange(key, range[:min], range[:max]) if range[:min].present? || range[:max].present?
				end
			end
		end
		if (defaults = filterize_options).present?
			if (order = defaults[:order]).present? && (defaults[:order_if].blank? || (defaults[:order_if].call(@filterable) rescue false) || (self.send(defaults[:order_if], @filterable) rescue false))
				collection = collection.forder order
			end
			if (scope = defaults[:scope]).present? && (defaults[:scope_if].blank? || (defaults[:scope_if].call(@filterable) rescue false) || (self.send(defaults[:scope_if], @filterable) rescue false))
				collection = collection.send(scope.to_s)
			end
			if (exclude = defaults[:exclude]).present? && (defaults[:exclude_if].blank? || (defaults[:exclude_if].call(@filterable) rescue false) || (self.send(defaults[:exclude_if], @filterable) rescue false))
				collection = collection.where.not(exclude)
			end
		end
		instance_variable_set('@' + object.name.pluralize.downcase, collection)
	end
end