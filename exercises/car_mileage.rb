class Car
  attr_writer :mileage

  def initialize
    @mileage = 0
  end

  def increment_mileage(miles)
    total = self.mileage + miles
    self.mileage = total
  end

  def print_mileage
    puts self.mileage
  end

  private

  attr_reader :mileage
end

car = Car.new
car.mileage = 5000
car.increment_mileage(678)
car.print_mileage
