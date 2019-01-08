$value_generators << ScriptedColumnValueGenerator.new("Top-Level Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND flag:top_level"
	next nuix_case.count(modified_query)
end