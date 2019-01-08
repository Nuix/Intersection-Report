class CustodianCategoryProvider < CategoryProviderBase
	def label
		return "Custodian"
	end

	def named_queries(scope_query)
		custodians = $current_case.getAllCustodians
		return custodians.map{|custodian_name| NamedQuery.new(custodian_name,"custodian:\"#{custodian_name}\"")}
	end
end