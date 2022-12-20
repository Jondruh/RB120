require 'pry'
# Rock, Paper, Scissors is a two-player game where each player simultaneously
# reveals one of three moves. Each move beats one of the other moves as follows:
# rock beats scissors
# scissors beats paper
# paper beats rock
#
# if the players show the same move it is a tie.
#
# Nouns: player, move, rule
# Verbs: choose, compare
#
# Player
#   - choose
# Move
# Rule
#
# - compare
#
# class History
#   attr_reader :game

#   def initialize(game)
#     @game = game
#     @history = []
#   end

#   def to_s
#     @history.each_with_index do |round, ind|
#       puts round
#     end
#     ''
    
#   end

#   def store_round(round)
#     @history << " -- Computer: #{round.game.computer.move} -- #{round.game.human.name}: #{round.game.human.move} -- Winner: #{round.winner}"
#   end

#   private

#   def format_round(round)
#   end


# end

#Gets moves from computer and human player and sets the winner
# class Round
#   attr_accessor :winner
#   attr_reader :game 

#   def initialize(game)
#     @game = game
#     @winner = nil
#   end

#   def set_winner
#     if game.human.move > game.computer.move
#       self.winner = :human
#     elsif game.human.move < game.computer.move
#       self.winner = :computer
#     else
#       self.winner = :tie
#     end
#   end

#   def play
#     game.computer.choose
#     game.human.choose
#     set_winner
#   end
# end

class RPSGame
  attr_accessor :human, :computer, :history, :round_count, :game_num, :round_winner

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_count = 0
    @history = []
    @game_num = 1
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, #{human.name}!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
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
    puts "\nThe score is: #{human.name}: #{human.score}. #{computer.name}: #{computer.score} \n\n"
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
    puts "#{human.name} chose #{human.move}"
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

  #need game#, round# player_name + move, other_player_name + move, winner of round
  def store_round
    history << "Game: #{game_num} Round: #{round_count} - #{human.name} played #{human.move} and #{computer.name} played #{computer.move} - Winner: #{winner_name}"
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

  def play
    display_welcome_message

    loop do
      score_reset
      @round_count = 1
      loop do
        display_score

        human.choose
        computer.choose

        display_moves
        set_round_winner
        display_round_winner

        update_score
        store_round
        if game_over?
          store_game
          break
        end
        @round_count += 1
      end
      
      display_winner

      if play_again?
        @game_num += 1
      else
        break
      end

    end
    puts history
    display_goodbye_message
  end
end

class Move
  include Comparable

  attr_reader :value
  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def scissors?
    @value == 'scissors'
  end

  def paper?
    @value == 'paper'
  end

  def rock?
    @value == 'rock'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def <=>(other_move)
    if @value == other_move.value
      0
    elsif (rock? && (other_move.scissors? || other_move.lizard?)) ||
    (scissors? && (other_move.paper? || other_move.lizard?)) ||
    (lizard? && (other_move.spock? || other_move.paper?)) ||
    (spock? && (other_move.scissors? || other_move.rock?)) ||
    (paper? && (other_move.rock? || other_move.spock?))
      1
    elsif (rock? && (other_move.paper? || other_move.spock?)) ||
    (scissors? && (other_move.rock? || other_move.spock?)) ||
    (lizard? && (other_move.scissors? || other_move.rock?)) ||
    (spock? && (other_move.lizard? || other_move.paper?)) ||
    (paper? && (other_move.scissors? || other_move.lizard?))
      return -1
    end
  end
end

class Player
  attr_accessor :name, :move, :score

  def initialize
    @score = 0
    set_name
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
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

current = RPSGame.new.play

