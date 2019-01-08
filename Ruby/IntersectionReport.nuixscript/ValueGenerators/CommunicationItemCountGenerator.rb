$value_generators << ScriptedColumnValueGenerator.new("Communication Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND has-communication:1"
	next nuix_case.count(modified_query)
end