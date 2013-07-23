class Game
  def initialize(white, black)
    @white = white
    @black = black
    @board = Board.new
  end


end





class King < Stepper
  MOVE_DELTAS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, 1],
    [0, -1],
    [1, 0],
    [1, -1],
    [1, 1]
  ]

end
