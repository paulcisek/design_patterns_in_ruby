require 'singleton'

class DatabaseConnectionManager
	include Singleton

	def get_connection

	end	
end

class PreferenceManager
	def initialize
		@reader = PrefReader.new
		@writer = PrefWriter.new
		@preferences = { display_splash: false, background_color: :blue}
	end

	def save_preferences
		preferences = {}
		@writer.write(@DatabaseConnectionManager.instance, @preferences)
	end

	def get_preferences
		@preferences = @reader.read(DatabaseConnectionManager.instance)
	end
end

class PrefWriter
	def write(preferences)
		connection = DatabaseConnectionManager.instance.get_connection
	end
end

class PrefReader
	def read
		connection = DatabaseConnectionManager.instance.get_connection
	end
end