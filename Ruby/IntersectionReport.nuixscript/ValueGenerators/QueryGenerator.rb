$value_generators << ScriptedColumnValueGenerator.new("Query") do |nuix_case,query|
	next query
end