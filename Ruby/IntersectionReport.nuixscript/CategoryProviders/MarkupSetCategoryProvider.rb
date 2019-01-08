class MarkupSetCategoryProvider < CategoryProviderBase
	def label
		return "Markup Set"
	end

	def named_queries(scope_query)
		markup_sets = $current_case.getMarkupSets
		result = []
		markup_sets.each do |markup_set|
			result << NamedQuery.new(markup_set.getName,"markup-set:\"#{markup_set.getName}\"")
		end
		return result
	end
end