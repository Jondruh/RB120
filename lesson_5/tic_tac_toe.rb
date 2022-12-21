class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def [](key)
    @squares[key]
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_human_marker(squares)
    squares.map(&:marker).count(TTTGame.human.marker)
  end

  def count_computer_marker(squares)
    squares.map(&:marker).count(TTTGame.computer.marker)
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def draw # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----|-----|-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----|-----|-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :name

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  MARKERS = ['X', 'O']
  attr_reader :board, :human, :computer, :score

  def initialize
    clear
    display_welcome_message
    setup_players
    @board = Board.new
    reset_score
  end

  def play # Starts the game
    clear
    main_game
    display_goodbye_message
  end

  private

  def setup_players
    human_choose_marker
    computer_choose_marker
    choose_names
  end

  def computer_choose_marker
    choice = MARKERS.reject { |mark| mark == human.marker }.first
    @computer = Player.new(choice)
  end

  def human_choose_marker
    puts "Would you like to play as 'X' or 'O's? (x/o)?"
    choice = nil

    loop do
      choice = gets.chomp.upcase
      break if MARKERS.include?(choice)
      puts "Please choose 'x' or 'o'."
    end

    @human = Player.new(choice)
    @current_player = human.marker
  end

  def choose_names
    puts "Please enter your name."
    name = nil

    loop do
      name = gets.chomp
      break if !name.empty?
      puts "Please enter at least 1 character."
    end

    human.name = (name)
    computer.name = (["Rick", "Martha", "Jane"].sample)
  end

  def main_game # Main game loop
    loop do
      play_round
      if game_over?
        display_game_over_message
        break unless play_again?
        reset_score
      else
        ready_next
      end
      reset
    end
  end

  def play_round
    display_board
    players_move
    update_score(board.winning_marker)
    display_result
  end

  def players_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def update_score(winner)
    case winner
    when human.marker then score[human] += 1
    when computer.marker then score[computer] += 1
    end
  end

  def display_score
    puts "#{human.name}'s score: #{score[human]}." \
    " Computer #{computer.name}'s score: #{@score[@computer]}"
  end

  def ready_next
    puts "Press enter to go to the next game."
    gets.chomp
  end

  def game_over?
    @score.values.max == 5
  end

  def reset_score
    @score = { @human => 0, @computer => 0 }
  end

  def display_game_over_message
    puts "#{score.key(5).name} is the first to 5 points and wins!"
  end

  def clear
    system "clear"
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!\n"
    puts "First to 5 points wins!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye."
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}"
    display_score
    puts ""
    board.draw
  end

  def joinor(moves, seperator, last_seperator = 'or')
    return moves.last if moves.count == 1
    string = ""
    moves[0..-2].each { |ele| string << "#{ele}#{seperator} " }
    string << "#{last_seperator} #{moves.last}"
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys, ',')}): "
    square = nil

    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def paths_for_win(opponent)
    possible_win_states = Board::WINNING_LINES.reject do |array|
      array.map { |sq| board[sq].marker == opponent.marker }.include?(true)
    end

    possible_win_states.map! do |array|
      array.select { |num| board[num].unmarked? }
    end

    possible_win_states.reject!(&:empty?)

    possible_win_states
  end

  def computer_decision(min_comp_path, min_human_path)
    if min_comp_path.size == 1
      min_comp_path
    elsif min_human_path.size == 1
      min_human_path
    elsif min_comp_path.empty?
      board.unmarked_keys
    else
      min_comp_path
    end
  end

  def computer_moves
    comp_paths = paths_for_win(human)
    human_paths = paths_for_win(computer)

    min_comp_path = comp_paths.empty? ? [] : comp_paths.min_by(&:size)
    min_human_path = human_paths.empty? ? [] : human_paths.min_by(&:size)

    computer_move_list = computer_decision(min_comp_path, min_human_path)

    board[computer_move_list.sample] = computer.marker
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == "y"
  end

  def reset
    board.reset
    @current_player = human.marker
    clear
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_player = computer.marker
    else
      computer_moves
      @current_player = human.marker
    end
  end

  def human_turn?
    @current_player == human.marker
  end
end

game = TTTGame.new
game.play
