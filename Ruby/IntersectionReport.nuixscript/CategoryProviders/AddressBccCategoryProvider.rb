class AddressBccCategoryProvider < CategoryProviderBase
	def category_label
		return "Address - BCC"
	end

	def label
		return "Address - BCC (within scope)"
	end

	def can_be_column
		return false
	end

	def named_queries(scope_query)
		bcc_distinct_addresses = {}

		scope_items = $current_case.search(scope_query)
		scope_items.each do |item|
			comm = item.getCommunication
			if !comm.nil?
				comm.getBcc.map{|address_obj| bcc_distinct_addresses[address_obj.getAddress.downcase] = true}
			end
		end

		result = []
		result += bcc_distinct_addresses.keys.map{|address| NamedQuery.new(address,"bcc:\"#{address}\"")}
		result = result.sort_by{|nq| nq.getName}
		return result
	end
end