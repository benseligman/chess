class HumanPlayer
  def initialize(board, color)
    @board = board
    @color = color
  end

  def make_move
    puts @board
    puts "please enter the position of the piece you want to move and the position you'd like to move it to."
    gets.chomp.split(",").map(&:strip)
  end

end