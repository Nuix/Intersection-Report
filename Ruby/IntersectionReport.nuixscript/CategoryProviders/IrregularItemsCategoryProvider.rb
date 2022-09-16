class IrregularItemsCategoryProvider < CategoryProviderBase
	def label
		return "Irregular Item Category"
	end

	def named_queries(scope_query)
		categories = {
			"Corrupted Container" => "properties:FailureDetail AND NOT flag:encrypted AND has-text:0 AND ( has-embedded-data:1 OR kind:container OR kind:database )",
			"Unsupported Container" => "kind:( container OR database ) AND NOT flag:encrypted AND has-embedded-data:0 AND NOT flag:partially_processed AND NOT flag:not_processed AND NOT properties:FailureDetail",
			"Non-searchable PDFs" => "mime-type:application/pdf AND NOT content:*",
			"Text Updated" => "modifications:text_updated",
			"Bad Extension" => "flag:irregular_file_extension",
			"Unrecognised" => "kind:unrecognised",
			"Unsupported Items" => "NOT flag:encrypted AND has-embedded-data:0 AND ( ( has-text:0 AND has-image:0 AND NOT kind:multimedia AND NOT kind:system AND NOT kind:log AND NOT mime-type-tag:log-entry AND NOT mime-type:application/vnd.ms-shortcut AND NOT mime-type:application/x-contact AND NOT mime-type:application/vnd.ms-exchange-stm AND NOT flag:not_processed ) OR mime-type:application/vnd.lotus-notes )",
			"Empty" => "mime-type:application/x-empty",
			"Encrypted" => "flag:encrypted",
			"Decrypted" => "flag:decrypted",
			"Deleted" => "flag:deleted",
			"Corrupted" => "properties:FailureDetail AND NOT flag:encrypted",
			"Digest Mismatch" => "flag:digest_mismatch",
			"Text Stripped" => "flag:text_stripped",
			"Text Not Indexed" => "flag:text_not_indexed",
			"Licence Restricted" => "flag:licence_restricted",
			"Not Processed" => "flag:not_processed",
			"Partially Processed" => "flag:partially_processed",
			"Text Not Processed" => "flag:text_not_processed",
			"Images Not Processed" => "flag:images_not_processed",
			"Reloaded" => "flag:reloaded",
			"Poisoned" => "flag:poison",
			"Slack Space" => "flag:slack_space",
			"Unallocated Space" => "flag:unallocated_space",
			"Manually Added" => "flag:manually_added",
			"Carved" => "flag:carved",
			"Deleted File - All Blocks Available" => "flag:fully_recovered",
			"Deleted File - Some Blocks Available" => "flag:partially_recovered",
			"Deleted File - Metadata Recovered" => "flag:metadata_recovered",
			"Hidden Stream" => "flag:hidden_stream",
		}

		result = []
		categories.each do |name,query|
			result << NamedQuery.new(name,query)
		end
		return result
	end
end