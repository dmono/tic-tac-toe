# frozen_string_literal: true
require './lib/board'
require './lib/player'
require './lib/computer'

class TTTGame
  FIRST_TO_MOVE = "choose".freeze # 'human', 'computer', or 'choose'
  WIN_SCORE = 5

  attr_reader :board, :human, :computer, :keep_playing

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Computer.new
    @first_player = nil
    @current_marker = nil
    @keep_playing = nil
  end

  def play
    game_setup

    loop do
      round_setup
      round_play

      break if !keep_playing || !play_again?
      reset_game
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "First player to win #{WIN_SCORE} rounds is the winner."
    puts ""
  end

  def display_names
    puts "Hi #{human.name}! Your opponent is #{computer.name}."
    puts ""
  end

  def set_first_player
    if FIRST_TO_MOVE == "human"
      @first_player = human.marker
    elsif FIRST_TO_MOVE == "computer"
      @first_player = computer.marker
    else
      choose_first_player
    end
  end

  def choose_first_player
    choice = nil
    loop do
      puts "Choose the first player to move: (y)ou, (c)omputer or (r)andom"
      choice = gets.chomp.downcase
      break if %(y c r).include?(choice)
      puts "Sorry, that's not a valid choice. Enter y, c, or r."
    end

    @first_player = if choice == 'y'
                      human.marker
                    elsif choice == 'c'
                      computer.marker
                    else
                      [human.marker, computer.marker].sample
                    end
  end

  def game_setup
    clear
    display_welcome_message
    human.set_name
  end

  def round_setup
    computer.set_name
    display_names
    human.set_marker
    computer.assign_marker(human)
    set_first_player
    set_current_marker
  end

  def set_current_marker
    @current_marker = @first_player
  end

  def round_play
    loop do
      display_board

      loop do
        current_player_moves
        alternate_player
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      update_score
      round_results
      break if game_winner?
      @keep_playing = start_next_round?
      break unless keep_playing
      reset_round
    end
  end

  def round_results
    display_result
    display_score
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye #{human.name}!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  def display_board
    puts "#{human.name} is an #{human.marker}. #{computer.name} is \
an #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, delimiter=', ', word="or")
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.size == 2 ? arr.join(' ') : arr.join(delimiter)
  end

  def human_moves
    puts "Choose a square: #{joinor(board.unmarked_keys)}"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    # Computer offense
    square = board.find_at_risk_square(computer.marker)

    # Computer defense
    square = board.find_at_risk_square(human.marker) unless square

    square = 5 unless square || !board.unmarked_keys.include?(5)

    square = board.unmarked_keys.sample unless square

    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
    else
      computer_moves
    end
  end

  def alternate_player
    @current_marker = if @current_marker == human.marker
                        computer.marker
                      else
                        human.marker
                      end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won this round!"
    when computer.marker
      puts "#{computer.name} won this round!"
    else
      puts "It's a tie!"
    end

    puts "Congratulations! You won the game!" if human.score == WIN_SCORE
    puts "Sorry, you lost the game!" if computer.score == WIN_SCORE
  end

  def display_score
    puts "#{human.name}'s score: #{human.score} | #{computer.name}'s \
score: #{computer.score}"
    puts ""
  end

  def update_score
    case board.winning_marker
    when human.marker
      human.increment_score
    when computer.marker
      computer.increment_score
    end
  end

  def game_winner?
    human.score == WIN_SCORE || computer.score == WIN_SCORE
  end

  def start_next_round?
    answer = nil
    loop do
      puts "Would you like to start the next round? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset_round
    board.reset
    @current_marker = @first_player
    clear
  end

  def reset_game
    reset_round
    human.reset_score
    computer.reset_score
    computer.set_name
  end
end

game = TTTGame.new
game.play
