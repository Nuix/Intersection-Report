$value_generators << ScriptedColumnValueGenerator.new("Audited Size") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	audited_size_bytes = case_stats.getAuditSize(modified_query,{"deduplicate" => "none"})
	next FormatUtility.bytesToDynamicSize(audited_size_bytes,1)
end