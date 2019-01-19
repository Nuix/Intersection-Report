class ItemKindWithSummaryCategoryProvider < CategoryProviderBase
	def label
		return "Item Kind (All, With Summary)"
	end

	def category_label
		return "Item Kind"
	end

	def named_queries(scope_query)
		all_kinds = $utilities.getItemTypeUtility.getAllKinds.map{|kind|kind.getName}
		result = all_kinds.map{|kind_name| NamedQuery.new(kind_name.capitalize,"kind:\"#{kind_name}\"")}
		summary_query = result.map{|nq|nq.getQuery}.join(" OR ")
		result << NamedQuery.new("All Kinds",summary_query)
		return result
	end
end