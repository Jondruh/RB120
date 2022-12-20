class Person

  def initialize(name)
    @name = name
  end

  def name
    @name.clone
  end

end

person1 = Person.new("james")
person1.name.reverse!
puts person1.name
