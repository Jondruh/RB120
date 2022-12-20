class Pet
  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{@animal} named #{@name}"
  end
end

class Owner
  def initialize(name)
    @name = name
    @number_of_pets = 0
  end

  attr_reader :name
  attr_accessor :number_of_pets
end

class Shelter
  attr_reader :unadopted_pets

  def initialize
    @clients = {}
    @unadopted_pets = []
  end

  def adopt(owner, pet)
    @clients[owner] ? @clients[owner] << pet : @clients[owner] = [pet]
    owner.number_of_pets += 1
  end

  def board(pet)
    @unadopted_pets << pet
  end

  def print_unadopted
    puts 'The Animal Shelter has the following unadopted pets:'
    @unadopted_pets.each { |pet| puts pet }
    puts
  end

  def print_adoptions
    @clients.each do |owner, pets|
      puts "#{owner.name} has adopted the following pets:"
      pets.each { |pet| puts pet }
      puts
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.board(asta)
shelter.board(laddie)
shelter.board(fluffy)
shelter.board(kat)
shelter.board(ben)
shelter.board(chatterbox)
shelter.board(bluebell)

shelter.print_adoptions

shelter.print_unadopted

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal shelter has #{shelter.unadopted_pets.size} unadopted pets."
