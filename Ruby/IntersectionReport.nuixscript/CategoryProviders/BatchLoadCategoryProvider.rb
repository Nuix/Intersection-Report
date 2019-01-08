class BatchLoadCategoryProvider < CategoryProviderBase
	def label
		return "Batch Load Date"
	end

	def named_queries(scope_query)
		batch_loads = $current_case.getBatchLoads
		result = []
		batch_loads.each do |batch_load|
			result << batch_load.getLoaded.toString("YYYY/MM/dd HH:mm")
		end
		return result
	end
end