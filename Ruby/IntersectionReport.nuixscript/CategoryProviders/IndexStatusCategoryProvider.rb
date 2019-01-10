class IndexStatusCategoryProvider < CategoryProviderBase
	def label
		return "Index Status"
	end

	def named_queries(scope_query)
		result = []
		result << NamedQuery.new("Text Indexed","flag:text_indexed")
		result << NamedQuery.new("Text Not Indexed","flag:text_not_indexed")
		result << NamedQuery.new("No Content","NOT flag:( text_indexed OR text_not_indexed )")
		return result
	end
end