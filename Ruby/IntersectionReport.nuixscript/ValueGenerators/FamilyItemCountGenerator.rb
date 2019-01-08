$value_generators << ScriptedColumnValueGenerator.new("Family Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0"
	items = nuix_case.search(modified_query)
	family_items = $utilities.getItemUtility.findFamilies(items)
	family_items = family_items.reject{|i|i.isExcluded}
	next family_items.size
end