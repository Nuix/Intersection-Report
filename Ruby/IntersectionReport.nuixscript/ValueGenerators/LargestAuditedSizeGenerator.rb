$value_generators << ScriptedColumnValueGenerator.new("Largest Audited Size (Dynamic)","Largest Audited Size") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	largest_audited_size = 0
	items = $current_case.search(modified_query)
	items.each do |item|
		next if !item.isAudited
		size = item.getAuditedSize
		if size > largest_audited_size
			largest_audited_size = size
		end
	end
	next FormatUtility.bytesToDynamicSize(largest_audited_size,1)
end