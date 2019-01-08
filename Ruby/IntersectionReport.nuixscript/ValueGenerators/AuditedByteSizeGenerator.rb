$value_generators << ScriptedColumnValueGenerator.new("Audited Size Bytes") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	audited_size_bytes = case_stats.getAuditSize(modified_query,{"deduplicate" => "none"})
	next audited_size_bytes
end