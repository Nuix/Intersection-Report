class ItemSetCategoryProvider < CategoryProviderBase
	def label
		return "Item Set"
	end

	def named_queries(scope_query)
		item_sets = $current_case.getAllItemSets
		return item_sets.map{|is| NamedQuery.new(is.getName,"item-set:#{is.getGuid}")}
	end
end