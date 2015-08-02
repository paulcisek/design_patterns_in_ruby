class Habitat
	def initialize(number_animals, number_plants, organism_factory)
		@organism_factory = organism_factory

		@animals = []
		number_animals.times do |i|
			animal = @organism_factory.new_animal("Animal#{i}")
			@animals << animal
		end

		@plants = []
		number_plants.times do |i|
			plant = @organism_factory.new_plant("Plant#{i}")
			@plants << plant
		end
	end

	def simulate_one_day
		@plants.each {|plant| plant.grow}
		@animals.each {|animal| animal.speak}
		@animals.each {|animal| animal.eat}
		@animals.each {|animal| animal.sleep}
	end

	def new_organism(type, name)
		if type == :animal
			@animal_class.new(name)
		elsif type == :plant
			@plant_class.new(name)
		else
			raise "Unknown organism type: #{type}"
		end
	end
end

class Frog
	def initialize(name)
		@name = name
	end

	def eat
		puts("Frog #{@name} is eating.")
	end

	def speak
		puts("Frog #{@name} says Crooooaakk!")
	end

	def sleep 
		puts("Frog #{@name} doeasnt sleep; he croaks all night!")
	end
end

class Algae
	def initialize(name)
		@name = name
	end

	def grow
		puts("The Algae #{@name} soaks up the sun and grows")
	end
end

class WaterLily
	def initialize(name)
		@name = name
	end

	def grow
		puts("The water lily #{@name} gloats, soaks up the sun, and grows")
	end
end

class Duck
	def initialize(name)
		@name = name
	end

	def eat 
		puts("Duck #{@name} is eating")
	end

	def speak
		puts("Duck #{@name} says Quack")
	end

	def sleep
		puts("Duck #{@name} sleeps quitly")
	end
end

class Tree
	def initialize(name)
		@name = name
	end

	def grow
		puts("The tree #{@name} grows tall")
	end
end

class Tiger
	def initialize(name)
		@name = name
	end

	def eat
		puts("Tiger #{@name} eats anything it wants.")
	end

	def speak
		puts("Tiger #{@name} Roars!")
	end

	def sleep
		puts("Tiger #{@name} sleeps anywhere it wants.")
	end
end

class PondOrganismFactory
	def new_animal(name)
		Frog.new(name)
	end

	def new_plant(name)
		Algae.new(name)
	end
end

class JungleOrganismFactory
	def new_animal(name)
		Tiger.new(name)
	end
	def new_plant(name)
		Tree.new(name)
	end
end

class OrganismFactory
	def initialize(plant_class, animal_class)
		@plant_class = plant_class
		@animal_class = animal_class
	end

	def new_animal(name)
		@animal_class.new(name)
	end

	def new_plant(name)
		@plant_class.new(name)
	end
end

jungle_organism_factory = OrganismFactory.new(Tree, Tiger)
pond_organism_factory = OrganismFactory.new(WaterLily, Frog)


jungle = Habitat.new(1, 4, jungle_organism_factory)
jungle.simulate_one_day

pond = Habitat.new(2, 4, pond_organism_factory)
pond.simulate_one_day
				