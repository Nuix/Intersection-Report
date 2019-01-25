Intersection Report
===================

![Last tested in Nuix 7.6](https://img.shields.io/badge/Nuix-7.6-green.svg)

View the GitHub project [here](https://github.com/Nuix/Intersection-Report) or download the latest release [here](https://github.com/Nuix/Intersection-Report/releases).

# Overview

**Written By:** Jason Wells

This script generates Excel spreadsheet reports where cell values are based on the intersection of a given cell's row category and column category.  Nested within a given column category is a series of sub-columns which report various values about the items corresponding to the row and column categories.  This may be best explained with an example.

![image](https://user-images.githubusercontent.com/11775738/50987968-e54f4f80-14bf-11e9-83f7-fe5c7976509d.png)

The image above is a sheet from a sample report.  For this sheet I have selected a row category of "Item Kind" and a column category that is a short list of search terms I provided.  I have also selected the following value generators (the sub-columns):
- Item Count
- Immaterial Count
- Audited Size
- Earliest Date
- Latest Date

So for the item kind category, internally a series of Nuix queries is provided:
- `kind:email`
- `kind:document`
- `kind:spreadsheet`
- etc.

For the primary column categories, each term is also a query:
- `hello`
- `access`
- `circuit`

Lets take a closer look at the first bit of the sheet.

![image](https://user-images.githubusercontent.com/11775738/50988520-b639dd80-14c1-11e9-834e-8197d6709cca.png)

To generate the values for the first term column the script first generates a Nuix query using the relevant row and column queries like so:

`(kind:email) AND (hello)`

This query is then provided in turn to each value generator, which then decides how to use this query to resolve its value.  For example [Item Count](https://github.com/Nuix/Intersection-Report/blob/master/Ruby/IntersectionReport.nuixscript/ValueGenerators/ItemCountGenerator.rb) determines how many items are responsive to the AND'ed query (`has-exclusion:0` is added in to remove excluded items):

```ruby
$value_generators << ScriptedColumnValueGenerator.new("Item Count") do |nuix_case,query|
	modified_query = "(#{query}) AND has-exclusion:0"
	next nuix_case.count(modified_query)
end
```

While a more complex value generator such as [Earliest Date](https://github.com/Nuix/Intersection-Report/blob/master/Ruby/IntersectionReport.nuixscript/ValueGenerators/EarliestDateGenerator.rb) runs a search to obtain the responsive items and performs some analysis to determine within that collection of items what the ealiest date is:

```ruby
$value_generators << ScriptedColumnValueGenerator.new("Earliest Date") do |nuix_case,query|
	java_import org.joda.time.DateTimeZone
	investigation_time_zone = DateTimeZone.forID(nuix_case.getInvestigationTimeZone)

	modified_query = "(#{query}) AND has-exclusion:0"
	items = nuix_case.search(modified_query)
	items = items.reject{|item| item.getDate.nil?}
	if items.size > 0
		items = items.sort_by{|item| item.getDate.getMillis}
		next items.first.getDate.withZone(investigation_time_zone).toString("YYYY/MM/dd")
	else
		next ""
	end
end
```

Head on over to the [Wiki](https://github.com/Nuix/Intersection-Report/wiki) to learn more about category providers and value generators.

The core implementation of the report can be found over in the [SuperUtilities](https://github.com/Nuix/SuperUtilities) repository in the namespace [com.nuix.superutilities.reporting](https://github.com/Nuix/SuperUtilities/tree/master/Java/src/main/java/com/nuix/superutilities/reporting).  This script provides the graphical user iterface (settings dialog and progress dialog) and the specific reporting implementation (category providers and column generators).

# Getting Started

## Setup

Begin by downloading the latest release of this code.  Extract the contents of the archive into your Nuix scripts directory.  In Windows the script directory is likely going to be either of the following:

- `%appdata%\Nuix\Scripts` - User level script directory
- `%programdata%\Nuix\Scripts` - System level script directory

## Cloning this Repository

This script relies on code from [Nx](https://github.com/Nuix/Nx) to present a settings dialog and progress dialog.  This JAR file is not included in the repository (although it is included in release downloads).  If you clone this repository, you will also want to obtain a copy of Nx.jar by either:
1. Building it from [the source](https://github.com/Nuix/Nx)
2. Downloading an already built JAR file from the [Nx releases](https://github.com/Nuix/Nx/releases)

Once you have a copy of Nx.jar, make sure to include it in the same directory as the scripts.

This script also relies on code from [SuperUtilities](https://github.com/Nuix/SuperUtilities), which contains the code to do the report generation.  This JAR file is not included in the repository (although it is included in release downloads).  If you clone this repository, you will also want to obtain a copy of SuperUtilities.jar by either:
1. Building it from [the source](https://github.com/Nuix/SuperUtilities)
2. Downloading an already built JAR file from the [Nx releases](https://github.com/Nuix/SuperUtilities/releases)

Once you also have a copy of SuperUtilities.jar, make sure to include it in the same directory as the scripts.

# License

```
Copyright 2018 Nuix

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```