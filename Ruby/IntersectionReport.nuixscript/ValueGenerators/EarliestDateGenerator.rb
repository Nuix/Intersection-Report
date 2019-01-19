$value_generators << ScriptedColumnValueGenerator.new("Earliest Date") do |nuix_case,query|
	java_import org.joda.time.DateTimeZone
	investigation_time_zone = DateTimeZone.forID(nuix_case.getInvestigationTimeZone)

	modified_query = "(#{query}) AND has-exclusion:0"
	items = nuix_case.search(modified_query)
	items = items.reject{|item| item.getDate.nil?}
	if items.size > 0
		items = items.sort_by{|item| item.getDate.getMillis}
		next items.first.getDate.withZone(investigation_time_zone).toString("YYYY/MM/dd")
	else
		next ""
	end
end