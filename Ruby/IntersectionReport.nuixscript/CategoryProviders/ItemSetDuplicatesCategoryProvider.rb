class ItemSetDuplicatesCategoryProvider < CategoryProviderBase
	def label
		return "Item Set Duplicates"
	end

	def named_queries(scope_query)
		item_sets = $current_case.getAllItemSets
		return item_sets.map{|is| NamedQuery.new(is.getName,"item-set-duplicates:#{is.getGuid}")}
	end
end