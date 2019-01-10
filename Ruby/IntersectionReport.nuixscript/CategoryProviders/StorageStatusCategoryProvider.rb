class StorageStatusCategoryProvider < CategoryProviderBase
	def label
		return "Storage Status"
	end

	def named_queries(scope_query)
		result = []
		result << NamedQuery.new("Text Stored","has-stored:text")
		result << NamedQuery.new("Binary Stored","has-stored:binary")
		result << NamedQuery.new("Thumbnail Stored","has-stored:image")
		return result
	end
end