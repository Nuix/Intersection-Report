class ItemKindWithinScopeCategoryProvider < CategoryProviderBase
	def label
		return "Item Kind (Within Scope, With Summary)"
	end

	def category_label
		return "Item Kind"
	end

	def named_queries(scope_query)
		all_kinds = $utilities.getItemTypeUtility.getAllKinds.map{|kind|kind.getName}
		result = []
		if scope_query.strip.empty?
			all_kinds.each do |kind_name|
				query = "kind:\"#{kind_name}\""
				if $current_case.count(query) > 0
					result << NamedQuery.new(kind_name.capitalize,query)
				end
			end
			summary_query = result.map{|nq|nq.getQuery}.join(" OR ")
			result << NamedQuery.new("All Kinds",summary_query)
			return result
		else
			all_kinds.each do |kind_name|
				query = "(#{scope_query}) AND (kind:\"#{kind_name}\")"
				if $current_case.count(query) > 0
					result << NamedQuery.new(kind_name.capitalize,"kind:\"#{kind_name}\"")
				end
			end
			summary_query = result.map{|nq|nq.getQuery}.join(" OR ")
			result << NamedQuery.new("All Kinds",summary_query)
			return result
		end
	end
end