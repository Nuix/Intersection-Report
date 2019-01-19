class ItemDateYearCategoryProvider < CategoryProviderBase
	def label
		return "Item Date (YYYY, Within Scope)"
	end

	def category_label
		return "Item Date"
	end

	def can_be_column
		return true
	end

	def named_queries(scope_query)
		java_import org.joda.time.DateTimeZone
		investigation_time_zone = DateTimeZone.forID($current_case.getInvestigationTimeZone)

		distinct_dates = {}
		scope_items = $current_case.search(scope_query)
		scope_items.each do |item|
			item_date = item.getDate
			if !item_date.nil?
				item_date = item_date.withZone(investigation_time_zone)
				item_date_string = item_date.toString("YYYY")
				item_date_display_string = item_date.toString("YYYY")
				distinct_dates[item_date_string] = item_date_display_string
			end
		end

		result = []
		distinct_dates.sort_by{|k,v|k}.each do |query_date,display_date|
			result << NamedQuery.new(display_date,"item-date:[#{query_date}0101 TO #{query_date}1231]")
		end
		result << NamedQuery.new("No Date","-item-date:*")
		return result
	end
end