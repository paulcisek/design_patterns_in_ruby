require 'observer'

module Subject
	def initialize 
		@observers=[]
	end

	def add_observer(&observer)
		@observers << observer
	end

	def delete_observer(observer)
		@observers.delete(observer)
	end

	def notify_observers
		@observers.each do |observer|
			observer.call(self)
		end
	end
end

class Employee
	include Subject
	attr_reader :name, :address
	attr_reader :salary

	def initialize(name, title, salary)
		super()
		@name = name
		@title = title
		@salary = salary
	end

	def salary=(new_salary)
		@salary = new_salary
		notify_observers
	end
end

fred = Employee.new('fred', 'Crane Operator', 30000)

fred.add_observer do |changed_employee|
	puts("Cut a new check for #{changed_employee.name}!")
	puts("His salary is now #{changed_employee.salary}!")
end

fred.salary=35000
