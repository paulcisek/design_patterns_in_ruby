require './RendererAdapter.rb'
class BritishTextObject
	def color
		return colour
	end

	def text
		return string
	end

	def size_inches
		return size_mm / 25.4
	end
end

bto = BritishTextObject.new('black')
puts bto.color