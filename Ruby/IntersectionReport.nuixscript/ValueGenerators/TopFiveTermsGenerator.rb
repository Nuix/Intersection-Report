$value_generators << ScriptedColumnValueGenerator.new("Top 5 Content Terms") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	terms = case_stats.getTermStatistics(modified_query,{"sort"=>"on","field"=>"content"})
	result = []
	terms.each do |term,count|
		break if result.size >= 5
		next if CategoryProviderBase.noise_terms[term] == true
		result << term
	end
	next result.join("; ")
end