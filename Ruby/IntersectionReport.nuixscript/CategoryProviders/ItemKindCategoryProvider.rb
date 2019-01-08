class ItemKindCategoryProvider < CategoryProviderBase
	def label
		return "Item Kind"
	end

	def named_queries(scope_query)
		all_kinds = $utilities.getItemTypeUtility.getAllKinds.map{|kind|kind.getName}
		return all_kinds.map{|kind_name| NamedQuery.new(kind_name.capitalize,"kind:\"#{kind_name}\"")}
	end
end