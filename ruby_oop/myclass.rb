# module Mymod
#   def hello
#     puts 'hi'
#   end
# end

# class MyClass
#   include Mymod
# end


# my_obj = MyClass.new

# my_obj.hello
#

# class GoodDog
#   attr_accessor :name, :weight

#   def initialize(name)
#     @name = name
#   end

#   def speak
#     "#{name} says Arf!"
#   end

#   def change_info(n, w)
#     self.name = n
#     self.weight = w
#   end

#   def display_info
#     "Name: #{name}. Weight #{weight}"
#   end
# end

# fido = GoodDog.new('Fido')

# puts fido.name
# fido.name = "Remy"
# puts fido.name

# puts fido.speak

# p fido.display_info
# fido.weight = '25.3lbs'
# p fido.weight

# puts fido.display_info
# fido.change_info("Spot", "50lbs")
# puts fido.display_info

class MyCar
  attr_accessor :color, :speed, :brake, :shut_off
  attr_reader :year, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @break = false
    @shut_off = false
  end

  def spray_paint
    puts "Your car is currently #{color}."
    puts "What color would you like to change to?"
    puts "1) Red - 2) Blue - 3) Green"
    input = gets.chomp

    case input
    when '1' then self.color = 'Red'
    when '2' then self.color = 'Blue'
    when '3' then self.color = 'Green'
    end

  end

end

suv = MyCar.new(1992, "red", "Rav4")

suv.spray_paint
puts suv.color
