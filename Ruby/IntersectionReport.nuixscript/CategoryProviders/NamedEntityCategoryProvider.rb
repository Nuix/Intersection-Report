class NamedEntityCategoryProvider < CategoryProviderBase
	def label
		return "Named Entity"
	end

	def named_queries(scope_query)
		entity_names = $current_case.getAllEntityTypes
		return entity_names.map{|name| NamedQuery.new(name,"named-entities:#{name};*")}
	end
end