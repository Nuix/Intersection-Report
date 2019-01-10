$value_generators << ScriptedColumnValueGenerator.new("Item Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0"
	next nuix_case.count(modified_query)
end