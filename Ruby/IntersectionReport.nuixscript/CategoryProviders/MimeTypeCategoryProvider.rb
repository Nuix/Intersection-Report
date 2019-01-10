class MimeTypeCategoryProvider < CategoryProviderBase
	def label
		return "Mime Type (All)"
	end

	def category_label
		return "Mime Type"
	end

	def named_queries(scope_query)
		all_types = $utilities.getItemTypeUtility.getAllTypes.map{|it| it.getName}.sort
		return all_types.map{|mime_type| NamedQuery.new(mime_type,"mime-type:\"#{mime_type}\"")}
	end
end