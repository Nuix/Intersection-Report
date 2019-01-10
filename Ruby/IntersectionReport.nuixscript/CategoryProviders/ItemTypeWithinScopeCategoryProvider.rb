class ItemTypeWithinScopeCategoryProvider < CategoryProviderBase
	def label
		return "Item Type (Within Scope)"
	end

	def category_label
		return "Item Type"
	end

	def named_queries(scope_query)
		all_types = $utilities.getItemTypeUtility.getAllTypes.sort_by{|it|it.getLocalisedName}
		result = []
		if scope_query.strip.empty?
			all_types.each do |type|
				query = "mime-type:\"#{type.getName}\""
				if $current_case.count(query) > 0
					result << NamedQuery.new(type.getLocalisedName,"mime-type:\"#{type.getName}\"")
				end
			end
		else
			all_types.each do |type|
				query = "(#{scope_query}) AND (mime-type:\"#{type.getName}\")"
				if $current_case.count(query) > 0
					result << NamedQuery.new(type.getLocalisedName,"mime-type:\"#{type.getName}\"")
				end
			end
		end
		return result
	end
end