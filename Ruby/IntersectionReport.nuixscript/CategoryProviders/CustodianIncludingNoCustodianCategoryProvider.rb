class CustodianIncludingNoCustodianCategoryProvider < CategoryProviderBase
	def label
		return "Custodian (Including 'No Custodian')"
	end

	def named_queries(scope_query)
		custodians = $current_case.getAllCustodians
		result = custodians.map{|custodian_name| NamedQuery.new(custodian_name,"custodian:\"#{custodian_name}\"")}
		result << NamedQuery.new("No Custodian","has-custodian:0")
		return result
	end
end