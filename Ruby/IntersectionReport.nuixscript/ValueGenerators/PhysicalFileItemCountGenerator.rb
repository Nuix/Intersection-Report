$value_generators << ScriptedColumnValueGenerator.new("Physical File Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0 AND flag:physical_file"
	next nuix_case.count(modified_query)
end