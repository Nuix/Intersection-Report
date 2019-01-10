class ProductionSetStatusCategoryProvider < CategoryProviderBase
	def label
		return "Production Set Status"
	end

	def named_queries(scope_query)
		result = []
		result << NamedQuery.new("Has Production Set","has-production-set:1")
		result << NamedQuery.new("No Production Set","has-production-set:0")
		return result
	end
end