class Mammal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end


class Dog < Mammal
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim"
  end
end

class Cat < Mammal
  def speak
    'meow!'
  end
end

teddy = Dog.new
bully = Bulldog.new

puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

puts bully.speak
puts bully.swim

