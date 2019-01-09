$value_generators << ScriptedColumnValueGenerator.new("Lowest Recipient Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND has-communication:1"
	items = nuix_case.search(modified_query)
	lowest = nil
	items.each do |item|
		comm = item.getCommunication
		recipient_count = comm.getTo.size + comm.getCc.size + comm.getBcc.size
		if lowest.nil? || recipient_count < lowest
			lowest = recipient_count
		end
	end
	next lowest || 0
end