load "./board.rb"
load "./player.rb"
require "./exceptions"

class Game
  attr_reader :current_player
  def initialize
    @board = Board.default_board
    self.create_players
    @current_player = :white
  end

  def self.new_game
    Game.new.play
  end

  def play
    until @board.over?(@current_player)
      new_turn
    end

    result
  end

  def result
    if @board.stalemate?(@current_player)
      puts "It's a tie!"
    elsif @board.checkmate?(:white)
      puts "BLACK wins!"
    else
      puts "WHITE wins!"
    end
    puts @board
    exit
  end

  def new_turn
    begin
      if @current_player == :white
        move = @white_player.make_move
      else
        move = @black_player.make_move
      end

      unless move.count == 2
        raise IllegalMoveError.new("Enter a start and a destination square separated by a comma.")
      end

      origin, destination = move

      if @board.square(origin).nil? ||
        @board.square(origin).color != @current_player
          raise IllegalMoveError.new("Move your own piece, please.")
      end

      @board.move(origin, destination)
      self.switch_player
    rescue IllegalMoveError => e
      puts "Invalid move! #{e.message}"
    end
  end

  def create_players
    puts "how many human players?"
    num_players = gets.chomp.to_i

    if num_players == 2
      @white_player = HumanPlayer.new(@board, :white)
      @black_player = HumanPlayer.new(@board, :black)
      puts "Two Human Players. Initializing... "
    elsif num_players == 1
      ##randomly assign player to a color and a computer to the other
    end
  end

  def switch_player
    @current_player = (@current_player == :white) ? :black : :white
  end


end






