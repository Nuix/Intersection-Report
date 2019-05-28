class AddressToCategoryProvider < CategoryProviderBase
	def category_label
		return "Address - To"
	end

	def label
		return "Address - To (within scope)"
	end

	def named_queries(scope_query)
		distinct_addresses = {}

		scope_items = $current_case.search(scope_query)
		scope_items.each do |item|
			comm = item.getCommunication
			if !comm.nil?
				comm.getTo.map{|address_obj| distinct_addresses[address_obj.getAddress.downcase] = true}
			end
		end

		result = []
		result += distinct_addresses.keys.map{|address| NamedQuery.new(address,"to:\"#{address}\"")}
		result = result.sort_by{|nq| nq.getName}
		return result
	end
end