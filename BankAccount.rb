require 'etc'
class BankAccount
	attr_reader :balance

	def initialize(starting_balance = 0)
		@balance = starting_balance
	end

	def deposit(amount)
		@balance += amount
	end

	def withdraw(amount)
		@balance -= amount
	end
end

class BankAccountProxy
	def initialize(real_object)
		@real_object = real_object
	end

	def balance
		@real_object.balance
	end

	def deposit(amount)
		@real_object.deposit(amount)
	end

	def withdraw(amount)
		@real_object.withdraw(amount)
	end
end

class AccountProtectionProxy
	def initialize(real_account, owner_name)
		@subject = real_account
		@owner_name = owner_name
	end

	def method_missing(name, *args)
		check_access
		@subject.send(name, *args)
	end
	def check_access
		if Etc.getlogin != @owner_name
			raise "Illegal access: #{Etc.getlogin} cannot access account."
		end
	end
end

class VirtualAccountProxy
	def initialize(&creation_block)
		@creation_block = creation_block
	end

	def method_missing(name, *args)
		s = subject
		s.send(name, *args)
	end

	def subject
		@subject || (@subject = @creation_block.call)
	end
end

class AccountProxy
	def initialize(real_account)
		@subject = real_account
	end

	def method_missing(name, *args)
		puts("Delegating #{name} message to subject")
		@subject.send(name, *args)
	end
end




account = BankAccount.new(100)
account.deposit(50)
account.withdraw(10)

proxy = BankAccountProxy.new(account)
proxy.deposit(50)
proxy.withdraw(10)

protection_proxy = AccountProtectionProxy.new(account, 'pc')
protection_proxy.balance

acc = VirtualAccountProxy.new{BankAccount.new(10)}

ap = AccountProxy.new(BankAccount.new(100))
ap.deposit(25)
ap.withdraw(50)
puts("account balance is now: #{ap.balance}")

array = VirtualAccountProxy.new {Array.new}

array << 'hello'
array << 'out'
array << 'there'

puts array

