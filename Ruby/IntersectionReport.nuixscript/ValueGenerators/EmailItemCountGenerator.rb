$value_generators << ScriptedColumnValueGenerator.new("Email Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND kind:email"
	next nuix_case.count(modified_query)
end