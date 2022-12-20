class Being
  def initialize
    puts "Being object created"
    @name = "Bob"
  end
end

class Human < Being
  attr_accessor :name
  def initialize
    puts "Human object created"
  end
end

human = Human.new
p human.name
