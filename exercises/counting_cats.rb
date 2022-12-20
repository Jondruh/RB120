class Cat
  @@total = 0

  def initialize
    @@total += 1
  end

  def self.total
    @@total
  end

end

kitty1 = Cat.new
kitty2 = Cat.new

puts Cat.total
