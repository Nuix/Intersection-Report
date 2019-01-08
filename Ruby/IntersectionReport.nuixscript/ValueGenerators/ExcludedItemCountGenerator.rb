$value_generators << ScriptedColumnValueGenerator.new("Excluded Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:1"
	next nuix_case.count(modified_query)
end