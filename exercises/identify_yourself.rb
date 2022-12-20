class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  # def identify
  #   self
  # end

  def to_s
    "I'm #{name}"
  end

  def inspect
    "I'm inspector #{name}"
  end
end

kitty = Cat.new('Sophie')
p kitty
