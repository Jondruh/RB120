class Person
  attr_reader :name

  def name=(input)
    @name = input.capitalize
  end
end

person1 = Person.new
person1.name = "eLiZaBeTh"
puts person1.name
