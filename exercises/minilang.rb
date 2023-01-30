class Minilang

  POP_METHODS = ['add', 'sub', 'mult', 'div', 'mod', 'pop']

  def initialize(program)
    @token_list = tokenizer(program)
    @reg = 0
    @stack = []
  end

  def eval
    @token_list.each do |token|
      begin
        if digit?(token)
          self.reg = token.to_i
        elsif POP_METHODS.include?(token.downcase) && stack.empty?
          raise EmptyStack
        else
          self.send(token.downcase)
        end
      rescue EmptyStack => e
        puts e.message
        break
      rescue NoMethodError
        puts "Invalid Token: #{token}"
        break
      end
    end
  end

  private

  attr_accessor :reg, :stack

  def digit?(arg)
    arg =~ /^[-+]?\d+$/
  end
    
  def tokenizer(program)
    program.split(' ')
  end

  def print
    puts reg
  end

  def push
    stack << reg
  end

  def add
    self.reg = reg + stack.pop
  end

  def sub
    self.reg = reg - stack.pop
  end

  def mult
    self.reg = reg * stack.pop
  end

  def div
    self.reg = reg / stack.pop
  end

  def mod
    self.reg = reg % stack.pop
  end

  def pop
    self.reg = stack.pop
  end

end

class EmptyStack < StandardError
  def message
    "Empty Stack!"
  end
end


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