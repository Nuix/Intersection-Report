class ItemTypeCategoryProvider < CategoryProviderBase
	def label
		return "Item Type (All)"
	end

	def category_label
		return "Item Type"
	end

	def named_queries(scope_query)
		all_types = $utilities.getItemTypeUtility.getAllTypes.sort_by{|it|it.getLocalisedName}
		return all_types.map{|type| NamedQuery.new(type.getLocalisedName,"mime-type:\"#{type.getName}\"")}
	end
end