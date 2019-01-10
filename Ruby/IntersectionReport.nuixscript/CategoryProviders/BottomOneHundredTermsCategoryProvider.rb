class BottomOneHundredTermsCategoryProvider < CategoryProviderBase
	def label
		return "Terms (Content Bottom 100)"
	end

	def category_label
		return "Terms"
	end

	def named_queries(scope_query)
		noise_terms = [
			"a", "an", "and", "are", "as", "at", "be", "but", "by",
			"for", "if", "in", "into", "is", "it", "i", "you", "we", "me",
			"no", "not", "of", "on", "or", "such",
			"that", "the", "their", "then", "there", "these",
			"they", "this", "to", "was", "will", "with",
		]
		(0..9).each{|n| noise_terms << "#{n}"} # Remove single digits
		("a".."z").each{|n| noise_terms << "#{n}"} # Remove single letters
		noise_terms = Hash[noise_terms.collect{|t| [t,true] }]

		case_stats = $current_case.getStatistics
		terms = case_stats.getTermStatistics(scope_query,{"sort"=>"on","field"=>"content"}).map{|term,count| term }
		bottom_terms = []
		terms.reverse.each do |term,count|
			break if bottom_terms.size >= 100
			next if noise_terms[term] == true
			bottom_terms << term
		end
		return bottom_terms.map{|t| NamedQuery.new(t,t)}
	end
end