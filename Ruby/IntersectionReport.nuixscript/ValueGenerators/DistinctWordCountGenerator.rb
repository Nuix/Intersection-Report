$value_generators << ScriptedColumnValueGenerator.new("Distinct Word Count") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	word_count = case_stats.getTermStatistics(modified_query).size
	next word_count
end