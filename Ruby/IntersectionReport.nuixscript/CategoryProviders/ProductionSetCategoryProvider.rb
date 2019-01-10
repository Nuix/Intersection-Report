class ProductionSetCategoryProvider < CategoryProviderBase
	def label
		return "Production Set"
	end

	def named_queries(scope_query)
		prod_sets = $current_case.getProductionSets
		return prod_sets.map{|ps| NamedQuery.new(ps.getName,"production-set-guid:#{ps.getGuid}")}
	end
end