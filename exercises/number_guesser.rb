class GuessingGame
  def initialize(lower, upper)
    @lower = lower.to_i
    @upper = upper.to_i
    @guesses = calc_guesses
    @player_guess = nil
    @number = rand(@lower..@upper)
  end

  def play
    loop do
      print_number_of_guesses
      prompt_for_guess
      print_guess_result

      if @player_guess == @number; puts "You won!"; break; end

      @guesses -= 1

      if @guesses == 0
        puts "You're out of guesses. You lost!"
        break
      end
    end
  end

  private
  attr_reader :lower, :upper

  def prompt_for_guess
    loop do 
      puts "Enter a number between #{lower} and #{upper}:"
      @player_guess = gets.chomp
      if valid_input?
        @player_guess = @player_guess.to_i
        break
      end
      print "Invalid guess. "
    end
  end

  def print_number_of_guesses
    puts "You have #{@guesses} remaining."
  end

  def print_guess_result
    if @player_guess > @number
      puts "Your guess is too high!"
    elsif @player_guess < @number
      puts "Your guess is to low!"
    elsif @player_guess == @number
      puts "That's the number!"
    end
  end

  def valid_input?
    @player_guess =~ /^\d+$/ && (lower..upper).cover?(@player_guess.to_i)
  end
    
  def calc_guesses
    Math.log2(upper - lower).to_i + 1
  end
end

game = GuessingGame.new(501, 1500)
game.play

