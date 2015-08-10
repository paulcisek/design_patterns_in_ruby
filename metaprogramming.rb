def new_plant(stem_type, leaf_type)
	plant = Object.new

	if stem_type == :fleshy
		def plant.stem
			'fleshy'
		end
	else
		def plant.stem
			'woody'
		end
	end

	if leaf_type == :broad
		def plant.leaf
			'broad'
		end
	else	
		def plant.leaf
			'needle'
		end
	end
	plant
end

plant1 = new_plant(:fleshy, :broad)
plant2 = new_plant(:woody, :needle)

puts "Plant 1's stem: #{plant1.stem} leaf: #{plant1.leaf}"
puts "Plant 2's stem: #{plant2.stem} leaf: #{plant2.leaf}" 

module Carnivore
	def diet
		'meat'
	end

	def teeth
		'sharp'
	end
end

module Herbivore
	def diet
		'plant'
	end

	def teeth
		'flat'
	end
end

module Noctural
	def sleep_time
		'day'
	end

	def awake_time
		'night'
	end
end

module Diurnal
	def sleep_time
		'night'
	end

	def awake_time
		'day'
	end
end

def new_animal(diet, awake)
	animal = Object.new

	if diet == :meat
		animal.extend(Carnivore)
	else
		animal.extend(Herbivore)
	end

	if awake == :day
		animal.extend(Diurnal)
	else
		animal.extend(Noctural)
	end

	animal
end

class CompositeBase
	attr_reader :name

	def initialize(name)
		@name = name
	end

	def self.member_of(composite_name)
		attr_name = "parent#{composite_name}"
		raise 'Method redefinition' if instance_methods.include(attr_name)
		code = %Q{
			attr_accessor :parent_#{composite_name}
		}
		class_eval(code)
	end

	def self.composite_of(composite_name)
		member_of composite_name

		code = %Q{
			def sub_#{composite_name}s
				@sub_#{composite_name}s = [] unless @sub_#{composite_name}s
				@sub_#{composite_name}s
			end

			def add_sub_#{composite_name}(child)
				return if sub_#{composite_name}s.include?(child)
				sub_#{composite_name}s << child
				child.parent_#{composite_name} = self
			end

			def delete_sub_#{composite_name}(child)
				return uless sub_#{composite_name}s.include?(child)
				sub_#{composite_name}s.delete(child)
				child.parent_#{composite_name} = nil
			end
		}
		class_eval(code)
	end
end
class Tiger < CompositeBase
	member_of(:population)
	member_of(:classification)
end

class Tree < CompositeBase
	member_of(:population)
	member_of(:classification)
end

class Jungle < CompositeBase
	composite_of(:population)
end

class Species < CompositeBase
	composite_of(:classification)
end
tony_tiger = Tiger.new('tony')
se_jungle = Jungle.new('southeastern jungle tigers')
se_jungle.add_sub_population(tony_tiger)
puts tony_tiger.parent_population

species = Species.new('P. tigris')
species.add_sub_classification(tony_tiger)
puts tony_tiger.parent_classification 

def member_of_composite?(object, composite_name)
	public_methods = object.public_methods
	public_methods.include("parent_#{composite_name}")
end

class Object
	def self.readable_attributes(name)
		code = %Q{
			def #{name}
				@#{name}
			end
		}
		class_eval(code)
	end
end

class BankAccount
	readable_attributes :balance

	def initialize(balance)
		@balance = balance
	end
end