$value_generators << ScriptedColumnValueGenerator.new("Email Descendant Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND path-kind:email"
	next nuix_case.count(modified_query)
end