class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    self.name = name
    self.grade = grade
  end

  def better_grade_than?(other)
    self.grade > other.grade
  end

  private

  attr_reader :grade

end

joe = Student.new("Joe", 89)
bob = Student.new("Bob", 78)

puts joe.better_grade_than?(bob)


