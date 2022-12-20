require 'pry'

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def test
    53.to_s
  end

  def to_s
    p "custom"
    "My name is #{@name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
binding.pry
puts fluffy.name
puts fluffy
puts fluffy.name
puts name
