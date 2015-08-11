require 'uri'

class Message
	attr_accessor :from, :to, :body

	def initialize(from, to, body)
		@from = from
		@to = URI.parse(to)
		@body = body
	end
end

class MessageGateway
	def initialize
		load_adapters
	end

	def process_message(message)
		adapter = adapter_for(message)
		adapter.send_message(message)
	end

	def adapter_for(message)
		protocol = message.to.scheme.downcase
		adapter_name = "#{protocol.capitalize}Adapter"
		adapter_class = self.class.const_get(adapter_name)
		adapter_class.new
	end

	def load_adapters
		lib_dir = File.dirname(__FILE__)
		full_pattern = File.join(lib_dir, 'adapter', '*.rb')
		Dir.glob(full_pattern).each{|file| require file}
	end

	def load_authorizers
		lib_dir = File.dirname(__FILE__)
		full_pattern = File.join(lib_dir, 'auth', '*.rb')
		Dir.glob(full_pattern).each{|file| require file}
	end

	def camel_case(string)
		tokens = string.split('.')
		tokens.map!{|t| t.capitalize}
		tokens.join('Dot')
	end

	def worm_case(string)
		tokens = string.split('.')
		tokens.map!{|t| t.downcase}
		tokens.join('_dot_')
	end

	def authorizer_for(message)
		to_host = message.to.host || 'default'
		authorizer_class = camel_case(to_host) + "Authorizer"
		authorizer_class = self.class.const_get(authorizer_class)
		authorizer_class.new
	end

	def authorized?(message)
		authorizer = authorizer_for(message)
		user_method = worm_case(message.from) + '_authorized?'
		if authorizer.respond_to?(user_method)
			return authorizer.send(user_method, message)
		end
		authorizer.authorized?
	end
end
