require 'pry'
# class Person
#   attr_accessor :name

#   def initialize(name)
#     @name = name
#   end

# end
#

class Person
  attr_accessor :first_name, :last_name

  def initialize(first, last = '')
    @first_name = first
    @last_name = last
  end

  def name
    (self.first_name + ' ' + self.last_name).strip
  end

  def name=(full_name)
    first, last = full_name.split
    @first_name = first
    @last_name = last
  end

end

binding.pry
