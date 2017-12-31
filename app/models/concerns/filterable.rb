module Filterable
  extend ActiveSupport::Concern
  
  module ClassMethods
    attr_reader :filterable_options

    def fsearch(search_string)
    	options = filterable_options[:search]
  		return nil if options.blank?
      strings = search_string.split(' ').map{|s| '%' + s + '%'}
      table_name = self.name.pluralize.downcase
  		sql = ''
      search_strings = []
  		options.each do |o|
        strings.each do |s|
          search_strings << s
          sql += table_name + '.' + o.to_s + ' LIKE ? OR '
        end
  		end
			self.where(sql[0...-4], *search_strings)
  	end

  	def forder(filter)
  		way = filter.to_s.slice(/_asc|_desc/).remove('_')
  		property = filter.to_s.remove(/_asc|_desc/)
  		unless self.column_names.include?(property)
  			property = property + '_id'
  		end
  		arguments = {}
  		arguments[property] = way
  		self.order(arguments)
	  end

	  def frange(property, min, max)
	  	options = filterable_options[:range]
	  	property = property.to_sym
	  	results = self.where(nil)
  		arguments = {}
  		arguments[property] = min.to_i..max.to_i if min.present? && max.present?
	  	arguments[property] = min.to_i..(1.0 / 0.0) if min.present? && max.blank?
	  	arguments[property] = 0..max.to_i if min.blank? && max.present?
	  	results.where(arguments)
	  end

    private
	    def filterable(options={})
	    	if @filterable_options.blank?
	    		@filterable_options = options
	    	else
	    		@filterable_options = @filterable_options.merge(options)
	    	end
	    end
  end
end