class IrregularItemsCategoryProvider < CategoryProviderBase
	def label
		return "Irregular Item Category"
	end

	def named_queries(scope_query)
		categories = {
			"Corrupted Container" => "properties:FailureDetail AND encrypted:0 AND has-text:0 AND ( has-embedded-data:1 OR kind:container OR kind:database )",
			"Unsupported Container" => "kind:( container OR database ) AND encrypted:0 AND has-embedded-data:0 AND NOT flag:partially_processed AND NOT flag:not_processed AND NOT properties:FailureDetail",
			"Non-searchable PDFs" => "mime-type:application/pdf AND contains-text:0",
			"Text Updated" => "previous-version-docid:*",
			"Bad Extension" => "flag:irregular_file_extension",
			"Unrecognised" => "kind:unrecognised",
			"Unsupported Items" => "encrypted:0 AND has-embedded-data:0 AND ( ( has-text:0 AND has-image:0 AND NOT flag:not_processed AND NOT kind:multimedia AND NOT mime-type:application/vnd.ms-shortcut AND NOT mime-type:application/x-contact AND NOT kind:system AND NOT mime-type:( application/vnd.logstash-log-entry OR application/vnd.ms-iis-log-entry OR application/vnd.ms-windows-event-log-record OR application/vnd.ms-windows-event-logx-record OR application/vnd.tcpdump.record OR filesystem/x-ntfs-logfile-record OR server/dropbox-log-event OR text/x-common-log-entry OR text/x-log-entry ) AND NOT mime-type:( application/vnd.logstash-log OR application/vnd.logstash-log-entry OR application/vnd.ms-iis-log OR application/vnd.ms-iis-log-entry OR application/vnd.ms-windows-event-log OR application/vnd.ms-windows-event-log-record OR application/vnd.ms-windows-event-logx OR application/vnd.ms-windows-event-logx-chunk OR application/vnd.ms-windows-event-logx-record OR application/vnd.tcpdump.pcap OR application/vnd.tcpdump.record OR application/x-pcapng OR server/dropbox-log OR server/dropbox-log-event OR text/x-common-log OR text/x-common-log-entry OR text/x-log-entry OR text/x-nuix-log ) AND NOT mime-type:application/vnd.ms-exchange-stm ) OR mime-type:application/vnd.lotus-notes )",
			"Empty" => "mime-type:application/x-empty",
			"Encrypted" => "encrypted:1",
			"Decrypted" => "flag:decrypted",
			"Deleted" => "deleted:1",
			"Corrupted" => "properties:FailureDetail AND NOT encrypted:1",
			"Text Stripped" => "flag:text_stripped",
			"Licence Restricted" => "flag:licence_restricted",
			"Not Processed" => "flag:not_processed",
			"Partially Processed" => "flag:partially_processed",
			"Text Not Processed" => "flag:text_not_processed",
			"Images Not Processed" => "flag:images_not_processed",
			"Reloaded" => "flag:reloaded",
			"Poisoned" => "flag:poison",
			"Slack Space" => "flag:slack_space",
			"Unallocated Space" => "flag:unallocated_space",
			"Carved" => "flag:carved",
			"Deleted File - All Blocks Available" => "flag:fully_recovered",
			"Deleted File - Some Blocks Available" => "flag:partially_recovered",
			"Deleted File - Metadata Recovered" => "flag:metadata_recovered",
			"Hidden Stream" => "flag:hidden_stream",
			"Text Not Indexed" => "flag:text_not_indexed",
		}

		result = []
		categories.each do |name,query|
			result << NamedQuery.new(name,query)
		end
		return result
	end
end