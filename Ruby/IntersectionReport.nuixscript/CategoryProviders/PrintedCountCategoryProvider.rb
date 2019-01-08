class PrintedCountCategoryProvider < CategoryProviderBase
	def label
		return "Printed"
	end

	def named_queries(scope_query)
		result = []
		result << NamedQuery.new("Printed","print-method:printed")
		result << NamedQuery.new("Not Printed","NOT has-stored:pdf")
		return result
	end
end