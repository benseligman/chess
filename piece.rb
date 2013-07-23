
class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(board, color)
    @color = color
    @board = board
  end

  def valid?(move, color)
    return false unless @board.on_board?(*move)
    (@board.empty?(*move) || (@board[*move].color != color)) ? true : false
  end



end

class Stepper < Piece
  #Knight, #King
  def possible_moves
    i, j = @position
    possible_moves = []

    self.move_deltas.each do |delta|
      new_position = [delta[0] + i, delta[1] + j]
      possible_moves << new_position
    end

    possible_moves.select { |move| self.valid?(move, @color) }
  end
end

class Slider < Piece

  DIRECTIONS = {
      :horizontal => [[0, 1], [0, -1]],
      :vertical => [[1, 0], [-1, 0]],
      :diagonal => [[-1, 1], [-1, -1], [1, 1], [1, -1]]
  }
  def possible_moves
    i, j = @position
    possible_moves = []

    self.move_deltas.each do |delta_i, delta_j|
      candidate = [i + delta_i, j + delta_j]
      possible_moves << candidate
      while @board.empty?(*candidate) && @board.on_board?(*candidate)
        p candidate
        candidate = [candidate[0] + delta_i, candidate[1] + delta_j]
        possible_moves << candidate
      end
    end

    possible_moves.select { |move| self.valid?(move, @color) }
  end


end

class Rook < Slider
  def move_deltas
    DIRECTIONS[:horizontal] + DIRECTIONS[:vertical]

  end

end

class Pawn < Stepper


  def move_deltas
    [[1, 0]]
  end
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

class Knight < Stepper
  def move_deltas
    [
      [-2, 1],
      [-2, -1],
      [2, -1],
      [2, 1],
      [-1, 2],
      [-1, -2],
      [1, 2],
      [1, -2]
    ]
  end
end