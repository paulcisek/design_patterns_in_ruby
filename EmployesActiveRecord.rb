class EmployeeObserver < ActiveRecord::Observer
	def after_create(employee)
	end
	def after_update(employee)
	end
	def after_destroy(employee)
	end
end