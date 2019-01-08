$value_generators << ScriptedColumnValueGenerator.new("No Item Set Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND has-item-set:0"
	next nuix_case.count(modified_query)
end