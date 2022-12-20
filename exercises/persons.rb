class Person
  def initialize(first, last)
    self.first_name = first
    self.last_name = last
  end

  def first_name=(first)
    @first_name = first.capitalize
  end

  def last_name=(last)
    @last_name = last.capitalize
  end

  def to_s
    "#{@first_name} #{@last_name}"
  end
end

person = Person.new('john', 'doe')
puts person

person.first_name = 'jane'
person.last_name = 'smith'
puts person
