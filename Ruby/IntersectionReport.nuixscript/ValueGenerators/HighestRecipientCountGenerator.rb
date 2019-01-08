$value_generators << ScriptedColumnValueGenerator.new("Highest Recipient Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND has-communication:1"
	items = nuix_case.search(modified_query)
	highest = 0
	items.each do |item|
		comm = item.getCommunication
		recipient_count = comm.getTo.size + comm.getCc.size + comm.getBcc.size
		if recipient_count > highest
			highest = recipient_count
		end
	end
	return highest
end