$value_generators << ScriptedColumnValueGenerator.new("Earliest Date") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0"
	items = nuix_case.search(modified_query)
	if items.size > 0
		items = items.reject{|item| item.getDate.nil?}
		items = items.sort_by{|item| item.getDate.getMillis}
		next items.first.getDate.toString("YYYY/MM/dd")
	else
		next ""
	end
end