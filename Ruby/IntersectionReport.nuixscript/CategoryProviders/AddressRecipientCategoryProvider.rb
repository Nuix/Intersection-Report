class AddressRecipientCategoryProvider < CategoryProviderBase
	def category_label
		return "Address - Recipient"
	end

	def label
		return "Address - Recipient (within scope)"
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
				comm.getTo.map{|address_obj| distinct_addresses[address_obj.getAddress.downcase] = true}
				comm.getCc.map{|address_obj| distinct_addresses[address_obj.getAddress.downcase] = true}
				comm.getBcc.map{|address_obj| distinct_addresses[address_obj.getAddress.downcase] = true}
			end
		end

		result = []
		result += distinct_addresses.keys.map{|address| NamedQuery.new(address,"to:\"#{address}\" OR cc:\"#{address}\" OR bcc:\"#{address}\"")}
		result = result.sort_by{|nq| nq.getName}
		return result
	end
end