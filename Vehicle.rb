class Vehicle
	
end

class Car 
	def initialize
		@engine = GasolineEngine.new
	end
	def sunday_drive
		start_engine
		stop_engine
	end
	def switch_to_diesel
		@engine = DieselEngine.new
	end
	def start_engine
		@engine.start
	end
	def stop_engine
		@engine.stop
	end
end	

class Engine 
	def start
		puts 'brru brruumm'
	end

	def stop
		puts 'sssssss'
	end
end	

class GasolineEngine < Engine
end

class DieselEngine < Engine
end		

car = Car.new
car.sunday_drive()		
