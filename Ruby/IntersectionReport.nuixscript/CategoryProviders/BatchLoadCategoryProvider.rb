class BatchLoadCategoryProvider < CategoryProviderBase
	def label
		return "Batch Load Date"
	end

	def named_queries(scope_query)
		batch_loads = $current_case.getBatchLoads
		result = []
		batch_loads.each do |batch_load|
			name = batch_load.getLoaded.toString("YYYY/MM/dd HH:mm")
			batch_id = batch_load.getBatchId
			query = "batch-load-guid:#{batch_id}"
			result << NamedQuery.new(name,query)
		end
		return result
	end
end