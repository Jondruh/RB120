class Person
  attr_reader :phone_number

  def initialize(number)
    @phone_number = number
  end
end

person1 = Person.new(123458590)
puts person1.phone_number

person1.phone_number = 909809824
puts person1.phone_number
