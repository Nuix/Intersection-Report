class PhysicalFileAncestorNameCategoryProvider < CategoryProviderBase
	def label
		return "Physical File Ancestor Name"
	end

	def can_be_column
		return false
	end

	def named_queries(scope_query)
		physical_file_items = $current_case.searchUnsorted("flag:physical_file")
		return physical_file_items.map{|item| NamedQuery.new(item.getLocalisedName,"path-guid:#{item.getGuid}")}
	end
end