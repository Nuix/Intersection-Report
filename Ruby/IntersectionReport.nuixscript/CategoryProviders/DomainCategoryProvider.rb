class DomainCategoryProvider < CategoryProviderBase
	def initialize
		super
		@domain_regex = /^.*@([^@]+)$/
	end

	def category_label
		return "Domain"
	end

	def label
		return "Domain (within scope)"
	end

	def can_be_column
		return false
	end

	def named_queries(scope_query)
		distinct_domains = {}
		
		scope_items = $current_case.search(scope_query)
		scope_items.each do |item|
			comm = item.getCommunication
			if !comm.nil?
				all_addresses = []
				all_addresses += comm.getFrom
				all_addresses += comm.getTo
				all_addresses += comm.getCc
				all_addresses += comm.getBcc
				
				all_addresses.each do |address_obj|
					domain = get_address_domain(address_obj.getAddress.downcase)
					distinct_domains[domain] = true
				end
			end
		end

		result = []
		result += distinct_domains.keys.map{|address| NamedQuery.new(address,"from-mail-domain:\"#{address}\" OR to-mail-domain:\"#{address}\" OR cc-mail-domain:\"#{address}\" OR bcc-mail-domain:\"#{address}\"")}
		result = result.sort_by{|nq| nq.getName}
		return result
	end

	# Uses the regular expression to attempt to extract the domain from
	# a given email address
	def get_address_domain(address)
		match = @domain_regex.match(address)
		if !match.nil?
			return match[1]
		else
			return "UNKNOWN DOMAIN"
		end
	end
end