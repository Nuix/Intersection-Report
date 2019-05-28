class AddressCcCategoryProvider < CategoryProviderBase
	def category_label
		return "Address - CC"
	end

	def label
		return "Address - CC (within scope)"
	end

	def can_be_column
		return false
	end

	def named_queries(scope_query)
		distinct_addresses = {}

		scope_items = $current_case.search(scope_query)
		scope_items.each do |item|
			comm = item.getCommunication
			if !comm.nil?
				comm.getCc.map{|address_obj| distinct_addresses[address_obj.getAddress.downcase] = true}
			end
		end

		result = []
		result += distinct_addresses.keys.sort.map{|address| NamedQuery.new(address,"cc:\"#{address}\"")}

		return result
	end
end