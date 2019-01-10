class PrintedStatusCategoryProvider < CategoryProviderBase
	def label
		return "Printed Status"
	end

	def named_queries(scope_query)
		result = []
		
		result << NamedQuery.new("Printed","print-method:printed")
		result << NamedQuery.new("Not Printed","NOT has-stored:pdf")
		result << NamedQuery.new("Text Converted","print-method:text_converted")
		result << NamedQuery.new("User Generated","print-method:imported_by_user")
		result << NamedQuery.new("OCR Generated","print-method:ocr_generated")
		
		result << NamedQuery.new("Slipsheet - User","print-method:slip_sheet_by_user")
		result << NamedQuery.new("Slipsheet - Unprintable","print-method:slip_sheet_unprintable")
		result << NamedQuery.new("Slipsheet - Encrypted","print-method:slip_sheet_encrypted")
		result << NamedQuery.new("Slipsheet - Error Printing","print-method:slip_sheet_error_printing")
		result << NamedQuery.new("Slipsheet - Too Large","print-method:slip_sheet_document_too_large")

		return result
	end
end