$value_generators << ScriptedColumnValueGenerator.new("Top 5 Content Terms") do |nuix_case,query|
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

	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	terms = case_stats.getTermStatistics(modified_query,{"sort"=>"on","field"=>"content"})
	result = []
	terms.each do |term,count|
		break if result.size >= 5
		next if noise_terms[term] == true
		result << term
	end
	next result.join("; ")
end