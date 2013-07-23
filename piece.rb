
class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(board, color)
    @color = color
    @board = board
  end



end

class Stepper < Piece
  #Knight, #King
  def possible_moves
    i, j = position
    possible_moves = []
    self.move_deltas.each do |delta|
      new_position = [delta[0] + i, delta[1] + j]
      possible_moves << new_position if @board.valid?(new_position, color)
    end

    possible_moves
  end
end

class Slider < Piece

end

class King < Stepper
  def move_deltas
    [
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
end
