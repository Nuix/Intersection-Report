# This script is hosted online at: https://github.com/Nuix/Intersection-Report

# Load Nx.jar and some useful classes from it.  This will enable use to
# easily show a settings dialog and progress dialog.
# Can be obtained on GitHub here: https://github.com/Nuix/Nx
script_directory = File.dirname(__FILE__)
require File.join(script_directory,"Nx.jar")
java_import "com.nuix.nx.NuixConnection"
java_import "com.nuix.nx.LookAndFeelHelper"
java_import "com.nuix.nx.dialogs.ChoiceDialog"
java_import "com.nuix.nx.dialogs.TabbedCustomDialog"
java_import "com.nuix.nx.dialogs.CommonDialogs"
java_import "com.nuix.nx.dialogs.ProgressDialog"
java_import "com.nuix.nx.dialogs.ProcessingStatusDialog"
java_import "com.nuix.nx.digest.DigestHelper"
java_import "com.nuix.nx.controls.models.Choice"

LookAndFeelHelper.setWindowsIfMetal
NuixConnection.setUtilities($utilities)
NuixConnection.setCurrentNuixVersion(NUIX_VERSION)

# Load SuperUtilities.jar which contains all the classes needed to perform
# the report generation.
# Can be obtained on GitHub here: https://github.com/Nuix/SuperUtilities
require File.join(script_directory,"SuperUtilities.jar")
java_import com.nuix.superutilities.SuperUtilities
java_import com.nuix.superutilities.reporting.IntersectionReport
java_import com.nuix.superutilities.reporting.IntersectionReportSheetConfiguration
java_import com.nuix.superutilities.reporting.NamedQuery
java_import com.nuix.superutilities.reporting.ScriptedColumnValueGenerator
java_import com.nuix.superutilities.misc.FormatUtility
$su = SuperUtilities.init($utilities,NUIX_VERSION)

# If $current_case is nil, then we are likely running from nuix_console executable and will need
# to own the case life cycle ourselves
default_case_directory = "C:\\"
script_opened_case = false
if $current_case.nil?
	case_directory = CommonDialogs.getDirectory(default_case_directory,"Choose Case to Open")
	if case_directory.nil? || case_directory.getPath.strip.empty?
		puts "User did not select a case to open, exiting..."
		exit 1
	else
		puts "Opening case: #{case_directory}"
		$current_case = $utilities.getCaseFactory.open(case_directory)
		puts "Case opened"
		script_opened_case = true
	end
end

# Load base class
load File.join(script_directory,"CategoryProviderBase.rb")

# Load category providers
category_providers_directory = File.join(script_directory,"CategoryProviders")
Dir.glob(File.join(category_providers_directory,"**","*.rb")).each do |file|
	load file
end

# Gets an instance of each class that derives from CategoryProviderBase (all the category providers)
category_providers = CategoryProviderBase.category_providers.sort_by{|cp| cp.label}
category_providers_by_label = {}
category_providers.each{|cp| category_providers_by_label[cp.label] = cp}

# Load each file in ValueGenerators directory, giving each a chance to add a scripted
# value generator to the list of choices
$value_generators = []
value_generators_directory = File.join(script_directory,"ValueGenerators")
Dir.glob(File.join(value_generators_directory,"**","*.rb")).each do |file|
	load file
end
$value_generators = $value_generators.sort_by{|vg|vg.label}

# Generate a default report file path
file_timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
default_report_path = File.join($current_case.getLocation.getPath,"Reports","IntersectionReport_#{file_timestamp}.xlsx")
default_report_path = default_report_path.gsub(/[\\\/]/,java.io.File.separator)

# Load column colors from file
puts "Loading column colors..."
column_colors = []
column_colors_file = File.join(script_directory,"ColumnColors.txt")
File.foreach(column_colors_file) do |line|
	if !line.strip.empty? && line !~ /^#/
		c = line.strip.split(",").map{|c|c.strip.to_i}
		column_colors << { :r => c[0], :g => c[1], :b => c[2] }
	end
end
puts "Loaded #{column_colors.size} colors"

# Load noise terms from file
puts "Loading noise terms..."
noise_terms_file = File.join(script_directory,"NoiseTerms.txt")
File.foreach(noise_terms_file) do |line|
	if !line.strip.empty? && line !~ /^#/
		CategoryProviderBase.noise_terms[line.strip] = true
	end
end
puts "Loaded #{CategoryProviderBase.noise_terms.size} noise terms"

# Build our settings dialog and settings tabs
dialog = TabbedCustomDialog.new("Intersection Report")
dialog.setTabPlacementLeft

main_tab = dialog.addTab("main_tab","Main")
main_tab.appendSaveFileChooser("report_file","Report File","Excel (*.xlsx)","xlsx")
main_tab.setText("report_file",default_report_path)
main_tab.doNotSerialize("report_file")
main_tab.appendCheckBox("open_report_when_finished","Open Report when Finished",true)

row_category_names = []
col_category_names = []

category_providers_by_label.each do |label,cat|
	if cat.can_be_row
		row_category_names << label
	end

	if cat.can_be_column
		col_category_names << label
	end
end

# Generate a settings tab for each sheet we will allow the user to generate
sheet_configuration_tab_count = 16
sheet_configuration_tab_count.times do |sheet_num|
	sheet_num += 1
	sheet_tab = dialog.addTab("sheet_#{sheet_num}_tab","Sheet #{sheet_num}")
	sheet_tab.appendCheckBox("#{sheet_num}_generate_sheet","Generate this sheet",false)
	sheet_tab.appendTextField("#{sheet_num}_sheet_name","Sheet Name","Sheet #{sheet_num}")
	sheet_tab.appendCheckBox("#{sheet_num}_freeze_panes","Freeze Headers",true)
	sheet_tab.appendTextArea("#{sheet_num}_scope_query","Scope Query","")
	sheet_tab.appendComboBox("#{sheet_num}_row_category","Row Category",row_category_names)
	sheet_tab.appendComboBox("#{sheet_num}_col_category","Column Primary",col_category_names)
	sheet_tab.appendHeader("Column Secondary")

	# Each choice table needs its own set of the choices since the Choice object carries the checked state
	# if we didn't do this then all the tables would reflect the same checked values
	sheet_tab.appendChoiceTable("#{sheet_num}_value_generators","",$value_generators.map{|vg| Choice.new(vg,vg.label)})

	sheet_tab.enabledOnlyWhenChecked("#{sheet_num}_sheet_name","#{sheet_num}_generate_sheet")
	sheet_tab.enabledOnlyWhenChecked("#{sheet_num}_freeze_panes","#{sheet_num}_generate_sheet")
	sheet_tab.enabledOnlyWhenChecked("#{sheet_num}_scope_query","#{sheet_num}_generate_sheet")
	sheet_tab.enabledOnlyWhenChecked("#{sheet_num}_row_category","#{sheet_num}_generate_sheet")
	sheet_tab.enabledOnlyWhenChecked("#{sheet_num}_col_category","#{sheet_num}_generate_sheet")
	sheet_tab.enabledOnlyWhenChecked("#{sheet_num}_value_generators","#{sheet_num}_generate_sheet")
end

terms_tab = dialog.addTab("terms_tab","Provided Terms")
terms_tab.appendLabel("terms_note","Terms to be used by 'Terms' category")
terms_tab.appendStringList("terms_list")

# Define how we are going to validate users settings
dialog.validateBeforeClosing do |values|
	# Validate user provided a place to save the report
	if values["report_file"].strip.empty?
		CommonDialogs.showWarning("Please specify a value for 'Report File'.")
		next false
	end

	# Validate settings for each enabled sheet
	all_sheets_valid = true
	sheet_configuration_tab_count.times do |sheet_num|
		sheet_num += 1

		# Skip if user did not enable this sheet
		next if values["#{sheet_num}_generate_sheet"] == false
		
		# Make sure user provided a sheet name
		if values["#{sheet_num}_sheet_name"].strip.empty?
			CommonDialogs.showWarning("Please provide a sheet name for sheet #{sheet_num}.")
			all_sheets_valid = false
			break
		end

		# Make sure sheet name is at most 30 characters long
		if values["#{sheet_num}_sheet_name"].size > 30
			CommonDialogs.showWarning("Sheet #{sheet_num} name exceeds Excel limit of 30 characters.")
			all_sheets_valid = false
			break
		end

		# Make sure at least 1 value generator is selected
		if values["#{sheet_num}_value_generators"].size < 1
			CommonDialogs.showWarning("Sheet #{sheet_num} has no secondary column types selected.  Please select at least 1.")
			all_sheets_valid = false
			break
		end

		# A report where row and col category are the same doesn't make much sense, so lets prevent it
		if values["#{sheet_num}_row_category"] == values["#{sheet_num}_col_category"]
			CommonDialogs.showWarning("Sheet #{sheet_num} has same category for rows and columns.")
			all_sheets_valid = false
			break
		end

		# Check scope query
		scope_query = values["#{sheet_num}_scope_query"]
		if scope_query.size > 0 && !scope_query.strip.empty?
			begin
				$current_case.search(scope_query,{"limit" => 0})
			rescue Exception => exc
				CommonDialogs.showWarning("Scope query for sheet #{sheet_num} appears to be invalid: #{exc.message}")
				all_sheets_valid = false
				break
			end
		end

		# Make sure that if any category provider needs terms defined, user has provided some
		terms = values["terms_list"]
		row_category = category_providers_by_label[values["#{sheet_num}_row_category"]]
		col_category = category_providers_by_label[values["#{sheet_num}_col_category"]]
		if (row_category.needs_terms || col_category.needs_terms) && terms.size < 1
			CommonDialogs.showWarning("Sheet #{sheet_num} is using a category which requires terms to be defined.  See 'Terms' tab.")
			all_sheets_valid = false
			break
		end
	end

	puts "All Sheets Valid: #{all_sheets_valid}"
	if !all_sheets_valid
		next false
	end

	next true
end

# Show the settings dialog
dialog.display

# If user selected OK and all settings are valid, lets get to work
if dialog.getDialogResult == true
	# Map of settings dialog values
	values = dialog.toMap

	CategoryProviderBase.terms = values["terms_list"]

	java.io.File.new(values["report_file"]).getParentFile.mkdirs
	report = IntersectionReport.new(values["report_file"])

	# Customize column primary category header colors
	column_category_color_ring = report.getColCategoryColorRing
	column_category_color_ring.clearColors
	column_colors.each do |color|
		column_category_color_ring.addColor(color[:r],color[:g],color[:b])
	end

	# Determine how many enabled sheets there are for the progress bar
	total_enabled_sheets = 0
	sheet_configuration_tab_count.times do |sheet_num|
		if values["#{sheet_num}_generate_sheet"]
			total_enabled_sheets += 1
		end
	end
	enabled_sheet_index = 0

	ProgressDialog.forBlock do |pd|
		pd.setTitle("Intersection Report")

		# Disable abort button
		pd.setAbortButtonVisible(false)

		# Make sure all messages logged to progress dialog also make their
		# way to standard out / the main Nuix log
		pd.onMessageLogged do |message|
			puts message
		end

		# Initialize the state of the main progress bar and setup callback
		# to update it when the report makes progress
		pd.setMainProgress(0,total_enabled_sheets)
		report.whenProgressUpdated do |current,total|
			pd.setSubProgress(current,total)
			pd.setSubStatus("Cell #{current}/#{total}")
		end

		# Hook up forwarding log message from report generator to progress dialog
		report.whenMessageGenerated do |message|
			pd.logMessage("  #{message}")
		end

		# Iterate each possibly sheet configuration tab from the settings dialog
		sheet_configuration_tab_count.times do |sheet_num|
			sheet_num += 1
			sheet_name = values["#{sheet_num}_sheet_name"]

			# Skip if user did not enable this sheet
			if values["#{sheet_num}_generate_sheet"] == false
				# pd.logMessage("Skipping disabled sheet #{sheet_num} '#{sheet_name}'")
				next
			end

			enabled_sheet_index += 1
			pd.setMainProgress(enabled_sheet_index)
			pd.setMainStatusAndLogIt("Configuring sheet #{sheet_num} '#{sheet_name}'")
			pd.setSubProgress(0,1)

			# Extract settings for this particular sheet
			row_category = category_providers_by_label[values["#{sheet_num}_row_category"]]
			col_category = category_providers_by_label[values["#{sheet_num}_col_category"]]
			value_generators = values["#{sheet_num}_value_generators"]
			scope_query = values["#{sheet_num}_scope_query"]

			# Create a sheet configuration object and populat it with the appropriate
			# settings from the settings dialog
			sheet_config = IntersectionReportSheetConfiguration.new

			# Row setup
			sheet_config.setRowCategoryLabel(row_category.category_label)
			sheet_config.setRowCriteria(row_category.named_queries(scope_query))
			
			# Primary column setup
			sheet_config.setColPrimaryCategoryLabel(col_category.category_label)
			sheet_config.setColCriteria(col_category.named_queries(scope_query))
			
			# Secondary column setup
			sheet_config.setValueGenerators(value_generators)
			
			# Set scope query
			sheet_config.setScopeQuery(scope_query)

			# Set whether 1st column and top 2 rows should be frozen (AKA freeze panes)
			sheet_config.setFreezePanes(values["#{sheet_num}_freeze_panes"])

			pd.setMainStatusAndLogIt("Generating sheet #{sheet_num} '#{sheet_name}'")
			report.generate($current_case,sheet_name,sheet_config)
		end

		pd.setCompleted

		if values["open_report_when_finished"]
			java.awt.Desktop.getDesktop.open(java.io.File.new(values["report_file"]))
		end
	end
end

# Close the case if we were the ones to open it
if script_opened_case == true
	$current_case.close
end