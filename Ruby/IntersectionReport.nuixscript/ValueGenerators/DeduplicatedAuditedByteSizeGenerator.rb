$value_generators << ScriptedColumnValueGenerator.new("Deduped Audited Size (Bytes)", "Deduped Audited Size") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	audited_size_bytes = case_stats.getAuditSize(modified_query,{"deduplicate" => "md5"})
	next audited_size_bytes
end