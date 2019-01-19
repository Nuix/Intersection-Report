class AllItemsCategoryProvider < CategoryProviderBase
	def label
		return "Overall"
	end

	def category_label
		return ""
	end

	def named_queries(scope_query)
		return [NamedQuery.new("Overall","")]
	end
end