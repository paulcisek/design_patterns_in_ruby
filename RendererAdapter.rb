class Renderer
	def render(text_object)
		text = text_object.text
		size = text_object.size_inches
		color = text_object.color

	end
end

class TextObject
	attr_reader :text, :size_inches, :color

	def initialize(text, size_inches, color)
		@text = text
		@size_inches = size_inches
		@color = color
	end
end

class BritishTextObject
	attr_reader :string, :size_mm, :colour
	def initialize(string, size_mm, colour)
		@colour = colour
		@string = string
		@size_mm = size_mm
	end
end

class BritishTextObjectAdapter < TextObject
	def initialize(bto)
		@bto = bto
	end

	def text 
		return @bto.string
	end

	def size_inches
		return @bto.size_mm / 25.4
	end

	def color
		return @bto.colour
	end
end

bto = BritishTextObject.new('hello', 50.8, :blue)

class << bto
	def color
		colour
	end
	def text
		string
	end
	def size_inches
		return size_mm / 25.4
	end
end

