class ItemSetOriginalsCategoryProvider < CategoryProviderBase
	def label
		return "Item Set Originals"
	end

	def named_queries(scope_query)
		item_sets = $current_case.getAllItemSets
		return item_sets.map{|is| NamedQuery.new(is.getName,"item-set-originals:#{is.getGuid}")}
	end
end