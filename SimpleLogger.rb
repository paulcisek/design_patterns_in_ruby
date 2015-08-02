require 'singleton'

class SimpleLogger
	attr_accessor :level

	ERROR = 1
	WARNING = 2
	INFO = 3

	def initialize
		@log = File.open("log.txt", "w")
		@level = WARNING
	end

	def error(msg)
		@log.puts(msg)
		@log.flush
	end

	def warning(msg)
		@log.puts(msg) if @level >= WARNING
		@log.flush
	end

	def info(msg)
		@log.puts(msg) if @level >= INFO
		@log.flush
	end

	@@instance = SimpleLogger.new

	def self.instance
		return @@instance
	end

	private_class_method :new
end

class SimpleLoggerSingleton
	include Singleton
end

class ClassBasedLogger
	ERROR = 1
	WARNING = 2
	INFO = 3

	@@log = File.open('log.txt', 'w')
	@@level = WARNING

	def self.error(msg)
		@@log.puts(msg)
		@@log.flush
	end

	def self.warning(msg)
		@@log.puts(msg) if @@level >= WARNING
		@@log.flush
	end

	def self.info(msg)
		@@log.puts(msg) if @@level >= INFO
		@@log.flush
	end

	def self.level=(new_level)
		@@level = new_level
	end

	def self.level
		@@level
	end
end	

module ModuleBasedLogger
	ERROR = 1
	WARNING = 2
	INFO = 3

	@@log = File.open("log.txt", "w")
	@@level = WARNING

	def self.error(msg)
		@@log.puts(msg)
		@@log.flush
	end
end

class Manager
	include Singleton

	def manage_resources
		puts('I am managing my resources')
	end
end

logger = SimpleLogger.new
logger.level = SimpleLogger::INFO

logger.info('Doing the first thing')
logger.info('Now doind the second thing')


ClassBasedLogger.level = ClassBasedLogger::INFO

ClassBasedLogger.info('Computer wins chess game.')
ClassBasedLogger.warning('AE-35 hardware failure predicted.')
ClassBasedLogger.error('HAL-9000 malfunction, take emergency action!')

ModuleBasedLogger.error('Computer wins chess game.')