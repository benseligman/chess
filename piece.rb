class Piece
  attr_accessor :position

  def initialize( board)
    @board = board
  end



end

class Stepper < Piece
  #Knight, #King
  def available_moves
    possible =

end

class Slider < Piece

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
