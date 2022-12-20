require 'pry'

class RPSGame
  attr_accessor :human, :computer, :history,
                :round_count, :game_num, :round_winner

  def initialize
    @human = Human.new
    @computer = [R2D2.new, Sonny.new, Chappie.new, Number5.new, Hal.new].sample
    @round_count = 0
    @history = []
    @game_num = 1
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard, #{human.name}!"
  end

  def display_goodbye_message
    puts history
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Goodbye!"
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, you must enter y or n."
    end

    answer.downcase == 'y'
  end

  def game_over?
    human.score == 3 || computer.score == 3
  end

  def display_score
    puts "\nThe score: #{human.name}: #{human.score}. " \
         "#{computer.name}: #{computer.score} \n\n"
  end

  def display_winner
    if human.score == 3
      puts "#{human.name} is the winner!"
    else
      puts "#{computer.name} is the winner!"
    end
  end

  def score_reset
    human.score = 0
    computer.score = 0
  end

  def display_moves
    puts "\n#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def update_score
    case round_winner
    when :human then human.score += 1
    when :computer then computer.score += 1
    end
  end

  def display_round_winner
    case round_winner
    when :human then puts "#{human.name} won!"
    when :computer then puts "#{computer.name} won!"
    when :tie then puts "It's a tie!"
    end
  end

  def winner_name
    case round_winner
    when :human then human.name
    when :computer then computer.name
    when :tie then "Tie"
    end
  end

  def store_round
    history << "Game: #{game_num} Round: #{round_count} - " \
               "#{human.name} played #{human.move} and #{computer.name} " \
               "played #{computer.move} - Winner: #{winner_name}"
  end

  def store_game
    history << "The winner of game #{game_num} was #{winner_name} \n\n"
  end

  def set_round_winner
    case human.move <=> computer.move
    when 1 then self.round_winner = :human
    when -1 then self.round_winner = :computer
    when 0 then self.round_winner = :tie
    end
  end

  def play_round
    human.choose
    computer.choose

    display_moves
    set_round_winner
    display_round_winner

    update_score
    display_score
    store_round
    @round_count += 1
  end

  def setup_round
    score_reset
    @round_count = 1
  end

  def round_wrap_up
    store_game
    display_winner
  end

  def play
    display_welcome_message

    loop do
      setup_round

      play_round until game_over?

      round_wrap_up

      break unless play_again?
      @game_num += 1
    end

    display_goodbye_message
  end
end

class Move
  include Comparable

  attr_reader :wins_against

  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']

  def <=>(other_move)
    if wins_against.include?(other_move.class)
      1
    elsif other_move.wins_against.include?(self.class)
      -1
    else
      0
    end
  end

  def to_s
    self.class.to_s
  end
end

class Rock < Move
  def initialize
    @wins_against = [Lizard, Scissors]
  end
end

class Lizard < Move
  def initialize
    @wins_against = [Spock, Paper]
  end
end

class Scissors < Move
  def initialize
    @wins_against = [Lizard, Paper]
  end
end

class Spock < Move
  def initialize
    @wins_against = [Rock, Scissors]
  end
end

class Paper < Move
  def initialize
    @wins_against = [Spock, Rock]
  end
end

class Player
  attr_accessor :name, :move, :score

  def initialize
    @score = 0
    set_name
  end

  private

  def new_move(move)
    case move
    when "rock" then Rock.new
    when "paper" then Paper.new
    when "scissors" then Scissors.new
    when "spock" then Spock.new
    when "lizard" then Lizard.new
    end
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end

    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, spock, lizard or scissors"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = new_move(choice)
  end
end

class Computer < Player
  def set_name
    self.name = self.class.to_s
  end

  def choose
    self.move = new_move(Move::VALUES.sample)
  end
end

class R2D2 < Computer
  def choose
    self.move = new_move('rock')
  end
end

class Hal < Computer
  def choose
    self.move = new_move(['rock', 'scissors', 'scissors', 'lizard'].sample)
  end
end

class Chappie < Computer
  def choose
    self.move = new_move(['rock', 'paper', 'scissors'].sample)
  end
end

class Sonny < Computer
  def choose
    self.move = new_move(['spock', 'spock', 'spock', 'lizard'].sample)
  end
end

class Number5 < Computer; def set_name; self.name = "Number 5"; end; end

RPSGame.new.play
