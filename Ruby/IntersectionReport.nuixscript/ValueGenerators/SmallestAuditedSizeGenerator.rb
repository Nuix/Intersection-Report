$value_generators << ScriptedColumnValueGenerator.new("Smallest Audited Size (Dynamic)","Smallest Audited Size") do |nuix_case,query|
	case_stats = nuix_case.getStatistics
	modified_query = "(#{query}) AND has-exclusion:0"
	smallest_audited_size = nil
	items = $current_case.search(modified_query)
	items.each do |item|
		next if !item.isAudited
		size = item.getAuditedSize
		if smallest_audited_size.nil? || size < smallest_audited_size
			smallest_audited_size = size
		end
	end
	next FormatUtility.bytesToDynamicSize(smallest_audited_size,1)
end