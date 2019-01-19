class ItemDateYearMonthCategoryProvider < CategoryProviderBase
	def label
		return "Item Date (YYYY/MM, Within Scope)"
	end

	def category_label
		return "Item Date"
	end

	def can_be_column
		return false
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
				last_day_of_month = item_date.dayOfMonth.getMaximumValue.to_s.rjust(2,"0")
				# Date searching is picky about last day of month you supply in range so we will
				# capture that here and build range from it below
				item_date_string = item_date.toString("YYYYMM#{last_day_of_month}")
				item_date_display_string = item_date.toString("YYYY/MM")
				distinct_dates[item_date_string] = item_date_display_string
			end
		end

		result = []
		distinct_dates.sort_by{|k,v|k}.each do |query_date,display_date|
			# We know last day of month/year for date, so we do a little regex to build first day of year/month value
			first_day_of_month = query_date.gsub(/([0-9]{6})[0-9]{2}/,"\\101")
			result << NamedQuery.new(display_date,"item-date:[#{first_day_of_month} TO #{query_date}]")
		end
		result << NamedQuery.new("No Date","-item-date:*")
		return result
	end
end