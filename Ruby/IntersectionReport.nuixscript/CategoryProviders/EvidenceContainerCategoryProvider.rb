class EvidenceContainerCategoryProvider < CategoryProviderBase
	def label
		return "Evidence Container"
	end

	def named_queries(scope_query)
		evidence_containers = $current_case.getRootItems.map{|i|{:guid=>i.getGuid,:name=>i.getName}}
		return evidence_containers.map{|entry| NamedQuery.new(entry[:name],"path-guid:\"#{entry[:guid]}\"")}
	end
end