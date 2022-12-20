class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end


  def self.who_dis
    puts self
  end

  def rename(name)
    self.name = name
  end
end

kitty = Cat.new("Sophie")
puts kitty.name
kitty.rename("Chloe")
puts kitty.name
kitty.class.who_dis

