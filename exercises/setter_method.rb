require 'pry'
class Test
  def initialize
    @name = "bob"
  end

  def name=(other_name)
    @name = other_name
    other_name.upcase!
  end
end

binding.pry
