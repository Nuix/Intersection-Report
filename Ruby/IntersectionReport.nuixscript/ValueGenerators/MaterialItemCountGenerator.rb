$value_generators << ScriptedColumnValueGenerator.new("Material Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND flag:audited"
	next nuix_case.count(modified_query)
end