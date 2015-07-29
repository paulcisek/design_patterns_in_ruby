class Encrypter
	def initialize(key)
		@key = key
	end

	def encrypt(reader, writer)
		key_index = 0
		while not reader.eof?
			clear_char = reader.getc
			encrypted_char = clear_char.ord ^ @key[key_index].ord
			writer.putc(encrypted_char)
			key_index = (key_index + 1) % @key.size
		end
	end
end
class StringIOAdapter
	def initialize(string)
		@string = string
		@position = 0 
	end

	def getc
		if @position >= @string.length
			raise EOFError
		end
		ch = @string[@position]
		@position += 1
		return ch.ord
	end

	def eof?
		return @position >= @string.length
	end
end


reader = File.open('message.txt')
writer = File.open('message.encrypted','w')
encrypter = Encrypter.new('my secret key')
encrypter.encrypt(reader, writer)

encrypter = Encrypter.new('XYZZY')
reader= StringIOAdapter.new('We attack at dawn')
writer=File.open('out.txt', 'w')
encrypter.encrypt(reader, writer)