require 'find'
def |(other)
	Or.new(self, other)
end
	
def &(other)
	And.new(self, other)
end

def all
	All.new
end

def bigger(size)
	Bigger.new(size)
end

def file_name(pattern)
	FileName.new(pattern)
end

def except(expression)
	Not.new(expression)
end

def writable
	Writable.new
end

class Expression
	def |(other)
		Or.new(self, other)
	end
	
	def &(other)
		And.new(self, other)
	end

	def all
		All.new
	end

	def bigger(size)
		Bigger.new(size)
	end
	
	def file_name(pattern)
		FileName.new(pattern)
	end
	
	def except(expression)
		Not.new(expression)
	end

	def writable
		Writable.new
	end
end

class All < Expression
	def evaluate(dir)
		puts dir
		results=[]
		Find.find(dir) do |p|
			next unless File.file?(p)
			results << p 
		end
		results
	end
end

class FileName < Expression
	def initialize(pattern)
		@pattern = pattern
	end

	def evaluate(dir)
		results = []
		Find.find(dir) do |p|
			next unless File.file?(p)
			name = File.basename(p)
			results << p if File.fnmatch(@pattern, name)
		end
		results
	end
end

class Bigger < Expression
	def initialize(size)
		@size = size
	end

	def evaluate(dir)
		results = []
		Find.find(dir) do |p|
			next unless File.file?(p)
			results << p if (File.size(p) > @size)
		end
		results
	end
end

class Writable < Expression
	def evaluate(dir)
		results = []
		Find.find(dir) do |p|
			next unless File.file?(p)
			results << p if (File.writable?(p))
		end
		results
	end
end

class Not < Expression
	def initialize(expression)
		@expression = expression
	end

	def evaluate(dir)
		All.new.evaluate(dir) - @expression.evaluate(dir)
	end
end

class Or < Expression
	def initialize(expression1, expression2)
		@expression1 = expression1
		@expression2 = expression2
	end

	def evaluate(dir)
		result1 = @expression1.evaluate(dir)
		result2 = @expression2.evaluate(dir)
		(result1 + result2).sort.uniq
	end
end

class And < Expression
	def initialize(expression1, expression2)
		@expression1 = expression1
		@expression2 = expression2
	end

	def evaluate(dir)
		result1 = @expression1.evaluate(dir)
		result2 = @expression2.evaluate(dir)
		(result1 & result2)
	end
end

class Parser
	def initialize(text)
		@tokens = text.scan(/\(|\)|[\w\.\*]+/)
	end

	def next_token
		@tokens.shift
	end

	def expression
		token = next_token
		
		if token == nil
			return nil
		elsif token == '('
			result = expression
			raise 'Expected )' unless next_token == ')'
			result
		elsif token == 'all'
			return All.new
		elsif token == 'writable'
			return Writable.new
		elsif token == 'bigger'
			return Bigger.new(next_token.to_i)
		elsif token == 'filename'
			return FileName.new(next_token)
		elsif token == 'not'
			return Not.new(expression)
		elsif token == 'and'
			return And.new(expression, expression)
		elsif token == 'or'
			return Or.new(expression, expression)
		else
			raise "Unexpected token: #{token}"
		end
	end
end

# dir = '../design_patterns_in_ruby'
# expr_all = All.new
# files = expr_all.evaluate(dir)

# puts "all files: #{files.count}"

# expr_txt = FileName.new('*.txt')
# txts = expr_txt.evaluate(dir)

# puts "all text files: #{txts.count}"

# expr_not_writable = Not.new(Writable.new)
# readonly_files = expr_not_writable.evaluate(dir)

# puts "all readonly files: #{readonly_files.count}"

# small_expr = Not.new( Bigger.new(1024) )
# small_files = small_expr.evaluate(dir)

# puts "all readonly files: #{small_files.count}"

# big_or_mp3_expr = Or.new( Bigger.new(1024), FileName.new('*.mp3') )
# big_or_mp3s = big_or_mp3_expr.evaluate(dir)

# complex_expression = And.new(
# 	And.new(
# 			Bigger.new(1024),
# 			FileName.new('*.mp3')
# 	),
# 	Not.new(Writable.new )
# )
# complex = complex_expression.evaluate(dir)

# puts "all complex expression files: #{complex.count}"

# parser = Parser.new "and (and(bigger 1024)(filename *.mp3)) writable"
# ast = parser.expression