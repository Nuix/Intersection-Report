=begin
A category provider class is expected to provide several things:
- An overall label for the rows or columns in the report
- A series of NamedQuery objects, each provides a name which is the label
  for a particular row or column and a query which will be used in the calculations
  for that row or column

For example if I want the rows to represent custodians in the case I might return
a label value of "Custodians" and provide 1 NamedQuery for each custodian in the case.
Each NamedQuery would have the name of the custodian and a query for the custodian like:
	custodian:"Bob Person"

Additionally methods can_be_row and can_be_column can return false to only present a given
category provider as an option for use by rows or columns.
=end
class CategoryProviderBase
	def label
		raise "You must override this method in the sub class"
	end

	def category_label
		return label
	end

	def named_queries(scope_query)
		raise "You must override this method in the sub class"
	end

	def can_be_row
		return true
	end

	def can_be_column
		return true
	end

	def self.category_providers
		ObjectSpace.each_object(Class).select{ |klass| klass < self }.map{|f|f.new}
	end
end