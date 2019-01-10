class LanguageCategoryProvider < CategoryProviderBase
	def label
		return "Language"
	end

	def named_queries(scope_query)
		languages = {
			"Afrikaans" => "lang:afr",
			"Dutch" => "lang:nld",
			"English" => "lang:eng",
			"Estonian" => "lang:est",
			"Finnish" => "lang:fin",
			"Italian" => "lang:ita",
			"Norwegian" => "lang:nor",
			"Spanish" => "lang:spa",
		}
		result = []
		languages.each do |name,query|
			result << NamedQuery.new(name,query)
		end
		return result
	end
end