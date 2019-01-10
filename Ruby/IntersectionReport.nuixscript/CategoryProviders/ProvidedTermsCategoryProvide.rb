class ProvidedTermsCategoryProvider < CategoryProviderBase
	def label
		return "Terms (Provided)"
	end

	def category_label
		return "Terms"
	end

	def needs_terms
		return true
	end

	def named_queries(scope_query)
		return CategoryProviderBase.terms.map{|t| NamedQuery.new(t,t)}
	end
end