class ProvidedTermsUniqueHitsCategoryProvider < CategoryProviderBase
	def label
		return "Terms (Provided,Unique Hits)"
	end

	def category_label
		return "Term Unique Hits"
	end

	def needs_terms
		return true
	end

	def named_queries(scope_query)
		result = []
		CategoryProviderBase.terms.each do |primary_term|
			other_terms = CategoryProviderBase.terms.reject{|t| t == primary_term}
			query = "(#{primary_term}) AND NOT (#{other_terms.join(" OR ")})"
			result << NamedQuery.new(primary_term,query)
		end
		return result
	end
end