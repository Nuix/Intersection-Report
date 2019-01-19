$value_generators << ScriptedColumnValueGenerator.new("Average Audited Size (Dynamic)","Average Audited Size") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	item_count = nuix_case.count(modified_query)
	if item_count == 0
		next FormatUtility.bytesToDynamicSize(0,1)
	end
	audited_size_bytes = case_stats.getAuditSize(modified_query,{"deduplicate" => "none"})
	average_audited_size_bytes = audited_size_bytes / item_count
	next FormatUtility.bytesToDynamicSize(average_audited_size_bytes,1)
end