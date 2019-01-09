$value_generators << ScriptedColumnValueGenerator.new("Top 5 Content Words") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	words = case_stats.getTermStatistics(modified_query,{"sort"=>"on","field"=>"content"})
	result = []
	words.each do |word,count|
		break if result.size >= 5
		result << word
	end
	next result.join("; ")
end