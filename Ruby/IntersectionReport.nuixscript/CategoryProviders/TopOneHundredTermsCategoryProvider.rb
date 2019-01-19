class TopOneHundredTermsCategoryProvider < CategoryProviderBase
	def label
		return "Terms (Content Top 100)"
	end

	def category_label
		return "Terms"
	end

	def named_queries(scope_query)
		case_stats = $current_case.getStatistics
		terms = case_stats.getTermStatistics(scope_query,{"sort"=>"on","field"=>"content"})
		top_terms = []
		terms.each do |term,count|
			break if top_terms.size >= 100
			next if CategoryProviderBase.noise_terms[term] == true
			top_terms << term
		end
		return top_terms.map{|t| NamedQuery.new(t,t)}
	end
end