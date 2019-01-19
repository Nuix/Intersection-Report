class BottomOneHundredTermsCategoryProvider < CategoryProviderBase
	def label
		return "Terms (Content Bottom 100)"
	end

	def category_label
		return "Terms"
	end

	def named_queries(scope_query)
		case_stats = $current_case.getStatistics
		terms = case_stats.getTermStatistics(scope_query,{"sort"=>"on","field"=>"content"}).map{|term,count| term }
		bottom_terms = []
		terms.reverse.each do |term,count|
			break if bottom_terms.size >= 100
			next if CategoryProviderBase.noise_terms[term] == true
			bottom_terms << term
		end
		return bottom_terms.map{|t| NamedQuery.new(t,t)}
	end
end