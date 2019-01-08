$value_generators << ScriptedColumnValueGenerator.new("Reloaded Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND flag:reloaded"
	next nuix_case.count(modified_query)
end