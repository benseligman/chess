load "./board.rb"
load "./player.rb"

class Game
  def initialize
    @board = Board.new
    self.create_players
    @current_player = :white
  end

  def play
    until @board.checkmate?(@current_player)
      if @current_player == :white
        move = @white_player.make_move
      else
        move = @black_player.make_move
      end
      @board.move(*move)
      self.switch_player
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






