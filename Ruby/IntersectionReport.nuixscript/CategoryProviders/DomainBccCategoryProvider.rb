class DomainBccCategoryProvider < CategoryProviderBase
	def initialize
		super
		@domain_regex = /^.*@([^@]+)$/
	end

	def category_label
		return "Domain - BCC"
	end

	def label
		return "Domain - BCC (within scope)"
	end

	def can_be_column
		return false
	end

	def named_queries(scope_query)
		bcc_distinct_domains = {}

		scope_items = $current_case.search(scope_query)
		scope_items.each do |item|
			comm = item.getCommunication
			if !comm.nil?
				comm.getBcc.each do |address_obj|
					domain = get_address_domain(address_obj.getAddress.downcase)
					bcc_distinct_domains[domain] = true
				end
			end
		end

		result = []
		result += bcc_distinct_domains.keys.map{|domain| NamedQuery.new(domain,"bcc-mail-domain:\"#{domain}\"")}
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