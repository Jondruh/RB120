class Minilang

  METHODS = ['add', 'sub', 'mult', 'div', 'mod', 'pop', 'push', 'print']

  def initialize(program)
    @reg = 0
    @stack = []
    @program = program
  end

  def eval
    begin
      tokenizer.each { |token| execute(token) }
    rescue MinilangError => e
      puts e.message
    end
  end

  def execute(token)
    if digit?(token)
      self.reg = token.to_i
    elsif METHODS.none?(token.downcase)
      raise InvalidTokenError, "Invalid Token: #{token}"
    else
      self.send(token.downcase)
    end
  end

  private

  attr_accessor :reg, :stack

  def digit?(arg)
    arg =~ /^[-+]?\d+$/
  end
    
  def tokenizer
    @program.split(' ')
  end

  def pop
    raise EmptyStackError, "Empty Stack!" if stack.empty?
    self.reg = stack.pop
  end

  def print
    puts reg
  end

  def push
    stack << reg
  end

  def add
    self.reg = reg + pop
  end

  def sub
    self.reg = reg - pop
  end

  def mult
    self.reg = reg * pop
  end

  def div
    self.reg = reg / pop
  end

  def mod
    self.reg = reg % pop
  end
end

class MinilangError < StandardError; end
class EmptyStackError < MinilangError; end
class InvalidTokenError < MinilangError; end


Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)