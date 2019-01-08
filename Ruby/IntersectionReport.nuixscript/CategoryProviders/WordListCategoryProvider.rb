class WordListCategoryProvider < CategoryProviderBase
	def label
		return "Word List"
	end

	def named_queries(scope_query)
		word_list_names = $utilities.getWordListStore.getWordListNames
		result = []
		word_list_names.each do |word_list_name|
			result << NamedQuery.new(word_list_name,"word-list:\"#{word_list_name}\"")
		end
		return result
	end
end