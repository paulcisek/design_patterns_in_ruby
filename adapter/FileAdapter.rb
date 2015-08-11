class FileAdapter
	def send(message)
		to_path = message.to.path
		to_path.slice(0)!

		File.open(to_path, 'w') do |f|
			f.write(message.text)
		end
	end
end