module Walkable
  def walk
    "#{self} #{gait} forward"
  end
end


class Animal
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "#{name}"
  end
end

class Person < Animal
  private

  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def to_s
    "#{title} #{name}"
  end

  private

  def gait
    "struts"
  end

end

class Cat < Animal
  private

  def gait
    "saunters"
  end
end

class Cheetah < Cat
  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
puts mike.walk

kitty = Cat.new("Kitty")
puts kitty.walk

flash = Cheetah.new("Flash")
puts flash.walk

byron = Noble.new("Byron", "Lord")
puts byron.walk
