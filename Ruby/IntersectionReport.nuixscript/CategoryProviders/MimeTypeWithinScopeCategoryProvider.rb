class MimeTypeWithinScopeCategoryProvider < CategoryProviderBase
	def label
		return "Mime Type (Within Scope)"
	end

	def category_label
		return "Mime Type"
	end

	def named_queries(scope_query)
		all_types = $utilities.getItemTypeUtility.getAllTypes.map{|it| it.getName}.sort
		result = []
		if scope_query.strip.empty?
			all_types.each do |mime_type|
				query = "mime-type:\"#{mime_type}\""
				if $current_case.count(query) > 0
					result << NamedQuery.new(mime_type,"mime-type:\"#{mime_type}\"")
				end
			end
		else
			all_types.each do |mime_type|
				query = "(#{scope_query}) AND (mime-type:\"#{mime_type}\")"
				if $current_case.count(query) > 0
					result << NamedQuery.new(mime_type,"mime-type:\"#{mime_type}\"")
				end
			end
		end
		return result
	end
end