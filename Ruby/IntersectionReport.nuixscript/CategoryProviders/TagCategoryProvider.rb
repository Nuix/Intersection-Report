class TagCategoryProvider < CategoryProviderBase
	def label
		return "Tag"
	end

	def named_queries(scope_query)
		tags = $current_case.getAllTags
		return tags.map{|tag| NamedQuery.new(tag.capitalize,"tag:\"#{tag}\"")}
	end
end