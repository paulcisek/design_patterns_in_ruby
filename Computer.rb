class Computer
	attr_accessor :display
	attr_accessor :motherboard
	attr_reader :drives

	def initialize(display = :crt, motherboard = Motherboard.new, drives = [])
		@motherboard = motherboard
		@drives = drives
		@display = display
	end
end

class CPU
end

class BasicCPU < CPU
end

class TurboCPU < CPU
end

class Motherboard
	attr_accessor :cpu
	attr_accessor :memory_size

	def initialize(cpu=BasicCPU.new, memory_size=1000)
		@cpu = cpu
		@memory_size = memory_size
	end
end	

class Drive
	attr_reader :type
	attr_reader :size
	attr_reader :writable

	def initialize(type, size, writable)
		@type = type
		@size = size
		@writable = writable
	end
end

class ComputerBuilder
	attr_reader :computer

	def turbo(has_turbo_cpu=true)
		@computer.motherboard.cpu = TurboCPU.new
	end

	def memory_size=(size_in_mb)
		@computer.motherboard.memory_size = size_in_mb
	end

	def computer
		raise "Not enough memory" if @computer.motherboard.memory_size < 250
		raise "Too many drives" if @computer.drives.size > 4
		hard_disk = @computer.drives.find {|drive| drive.type == :hard_disk}
		raise "No hard disk." unless hard_disk
		@computer
	end

	def method_missing(name, *args)
		words = name.to_s.split("_")
		return super(name, *args) unless words.shift == 'add'
		words.each do |word|
			next if word == 'and'
			add_cd if word == 'cd'
			add_dvd if word == 'dvd'
			add_hard_disk(100000) if word == 'harddisk'
			turbo if word == 'turbo'
		end
	end

end

class DesktopComputer < Computer
end

class LaptopComputer < Computer
	def initialize(motherboard=Motherboard.new, drives= [])
		super(:lcd, motherboard, drives)
	end
end

class DesktopBuilder < ComputerBuilder
	def initialize
		@computer = DesktopComputer.new
	end

	def display=(display)
		@computer.display=display
	end

	def add_cd(writer=false)
		@computer.drives << Drive.new(:cd, 760, writer)
	end

	def add_dvd(writer=false)
		@computer.drives << Drive.new(:dvd, 4000, writer)
	end

	def add_hard_disk(size_in_mb)
		@computer.drives << Drive.new(:hard_disk, size_in_mb, true)
	end
end

class LaptopBuilder < ComputerBuilder
	def initialize
		@computer = LaptopComputer.new
	end

	def display=(display)
		raise "Laptop display must be lcd" unless display == :lcd
	end

	def add_cd(writer=false)
		@computer.drives << LaptopDrive.new(:cd, 760, writer)
	end

	def add_dvd(writer=false)
		@computer.drives << LaptopDrive.new(:dvd, 4000, writer)
	end

	def add_hard_disk(size_in_mb)
		@computer.drives << LaptopDrive.new(:hard_disk, size_in_mb, true)
	end

	def reset
		@computer = LaptopComputer.new
	end
end




motherboard = Motherboard.new(TurboCPU.new, 4000)

drives = []
drives << Drive.new(:hard_drive, 200000, true)
drives << Drive.new(:cd, 760, true)
drives << Drive.new(:dvd, 4700, false)

computer = Computer.new(:lcd, motherboard, drives)

builder = ComputerBuilder.new
builder.turbo
builder.add_cd(true)
builder.add_dvd
builder.add_hard_disk(100000)

computer = builder.computer

