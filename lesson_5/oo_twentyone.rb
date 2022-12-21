class Player
  attr_accessor :hand, :score, :round_score
  attr_reader :name

  def initialize(name)
    @round_score = 0
    @name = name
    @hand = []
  end

  def display_hand(face_up: true)
    display = face_up ? hand.map(&:show) : hand.map(&:hide)

    # zips each line of the cards so the cards can be displayed in a row.
    joined = display.shift.zip(*display)
    joined.each { |line| puts line.join(" ") }
  end

  def busted?
    score > 21
  end

  def hand_sum
    hand.inject(0) { |memo, op| memo + op.points }
  end

  def set_total
    loop do
      break unless hand_sum > TwentyOne::BUST && hand.map(&:points).include?(11)
      aces = hand.select { |card| card.points == 11 }
      aces.first.subtract_ace
    end

    self.score = hand_sum
  end
end

class Dealer < Player
  DEALER_CUTOFF = 17

  def initialize
    super("Dealer")
  end

  def show_title(show_score: false)
    score_display = show_score ? score : "???"
    puts "Dealer's hand // Dealer's hand score: #{score_display}"
  end
end

class Human < Player
  def initialize
    super(choose_name)
  end

  def show_title
    puts "Your hand. // Your hand score: #{score}"
  end

  private

  def choose_name
    name = nil
    puts "Please enter a name:"
    loop do
      name = gets.chomp
      break if name.match?(/\S/)
      puts "Please enter at least one non-whitespace character"
    end
    name
  end
end

class Deck
  attr_accessor :cards

  SUITS = [{ spades: "\u2660" },
           { hearts: "\u2665" },
           { diamonds: "\u2666" },
           { clubs: "\u2663" }]

  def initialize
    @cards = []
    build_deck
  end

  def deal
    cards.shuffle!.pop
  end

  private

  def build_deck
    SUITS.each do |suit|
      (2..10).each { |num| cards << Card.new(suit.values[0], num.to_s) }
      %w(J Q K A).each { |face| cards << Card.new(suit.values[0], face) }
    end
  end
end

class Card
  attr_reader :suit, :value, :points

  def initialize(suit, value)
    @suit = suit
    @value = value
    set_worth
  end

  def show
    ["╭───╮",
     "│  #{suit}│",
     "│#{value.ljust(3)}│",
     "╰───╯"]
  end

  def hide
    ["╭───╮",
     "│  ?│",
     "│?  │",
     "╰───╯"]
  end

  def subtract_ace
    @points = 1
  end

  private

  def set_worth
    @points = score
  end

  def score
    if ("2".."10").include?(value)
      value.to_i
    elsif %w(K Q J).include?(value)
      10
    elsif value == "A"
      11
    end
  end
end

class TwentyOne
  BUST = 21

  attr_reader :human, :dealer, :deck, :round_winner, :busted_player

  def start # Main game
    setup_game
    loop do # Round loop
      setup_round
      human_turn
      dealer_turn if !human.busted?
      wrap_up_round

      break if game_over?
      player_ready_prompt
    end
    show_game_result
  end

  private

  def setup_game
    clear_screen
    display_welcome_message
    display_rules
    create_players
  end

  def setup_round
    empty_hands
    clear_round_winner
    clear_busted_player
    create_deck
    deal_cards
    display_table
  end

  def human_turn
    loop do
      input = hit_or_stay

      case input
      when 'h', 'hit' then
        deal_to(human)
        display_table
        break if human.busted?
      when 's', 'stay' then break
      end
    end
  end

  def dealer_turn
    until dealer.busted? || dealer.score >= Dealer::DEALER_CUTOFF
      deal_to(dealer)
    end
  end

  def wrap_up_round
    update_round_winner
    update_round_scores
    display_table(show_all_cards: true)
    display_round_winner
  end

  def player_ready_prompt
    puts "Press enter to go to next round"
    gets.chomp
  end

  def game_over?
    dealer.round_score == 5 || human.round_score == 5
  end

  def show_game_result
    winner = [human, dealer].max_by(&:round_score)

    puts "~" * 80
    puts "#{winner.name} has won 5 hands and is the overall winner!!"
    puts "~" * 80
  end

  def empty_hands
    human.hand = []
    dealer.hand = []
  end

  def busted_player_message
    busted_player ? "#{busted_player.name} went bust! " : ""
  end

  def display_round_winner
    if round_winner
      puts busted_player_message + "#{round_winner.name} has won the round!"
    elsif round_winner.nil?
      puts "It's a tie!"
    end
  end

  def update_round_scores
    @round_winner.round_score += 1 if round_winner
  end

  def update_round_winner
    if human.busted?
      @round_winner = dealer
      @busted_player = human
    elsif dealer.busted?
      @round_winner = human
      @busted_player = dealer
    elsif human.score != dealer.score
      @round_winner = [human, dealer].max_by(&:score)
    end
  end

  def clear_busted_player
    @busted_player = nil
  end

  def clear_round_winner
    @round_winner = nil
  end

  def create_deck
    @deck = Deck.new
  end

  def create_players
    @human = Human.new
    @dealer = Dealer.new
  end

  def clear_screen
    system "clear"
  end

  def deal_to(player)
    player.hand << deck.deal
    player.set_total
  end

  def hit_or_stay
    puts "Would you like to (h)it or (s)tay?"
    input = nil
    loop do
      input = gets.chomp.downcase
      break if %w(hit stay h s).include?(input)
      puts "Sorry, please enter 'h','hit', 'stay' or 's'"
    end
    input
  end

  def display_table(show_all_cards: false)
    clear_screen
    show_round_scores
    dealer.show_title(show_score: show_all_cards)
    dealer.display_hand(face_up: show_all_cards)

    human.show_title
    human.display_hand
  end

  def show_round_scores
    puts "#{human.name}'s Score: #{human.round_score}. " \
    "Dealer's Score: #{dealer.round_score}"
    puts line_spacer
  end

  def deal_cards
    2.times { deal_to(human) }
    2.times { deal_to(dealer) }
  end

  def hit(player)
    player.hand << deck.deal
  end

  def display_welcome_message
    puts "Hello! Welcome to Twenty-One!"
    puts line_spacer
  end

  def display_rules
    puts "To win, get closer to 21 points in your hand than the opponent."
    puts "Card worths are as follows:"
    puts "Face cards: 10 points, Aces: 11 or 1, Cards 2-10: worth their value."
    puts "You can 'hit' for another card, or 'stay' to keep your hand."
    puts "If either play goes over 21 they bust and the other player wins."
    puts "The first player to win 5 hands is the winner!\n"
    puts line_spacer
  end

  def line_spacer
    "-" * 80
  end
end

TwentyOne.new.start
