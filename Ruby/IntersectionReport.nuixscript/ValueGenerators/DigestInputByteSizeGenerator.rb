$value_generators << ScriptedColumnValueGenerator.new("Digest Input Size (Bytes)","Digest Input Size") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0"
	digest_input_size_bytes = 0
	items = nuix_case.searchUnsorted(modified_query)
	items.each do |item|
		digests = item.getDigests
		if !digests.nil?
			input_size = digests.getInputSize
			digest_input_size_bytes += input_size if !input_size.nil?
		end
	end
	next digest_input_size_bytes
end