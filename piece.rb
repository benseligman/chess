require "debugger"

#TODO: update to_s methods to use unicode chess chars: http://en.wikipedia.org/wiki/Chess_symbols_in_Unicode

class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(board, color)
    @color = color
    @board = board
  end

  # TODO: add Board.check and reference here
  def available_square?(destination, color)
    @board.on_board?(*destination) &&
      (@board.empty?(*destination) || (@board[*destination].color != color))
  end

  def into_check?(destination)
    board_copy = @board.dup
    board_copy.move!(@position, destination)
    board_copy.check?(@color)
  end

  def legal_moves
    l = self.possible_moves.reject { |destination| into_check?(destination) }
    p l
    l
  end

end #end PIECE




class Stepper < Piece
  def possible_moves
    i, j = @position
    possible_moves = []

    self.move_deltas.each do |delta|
      candidate = [delta[0] + i, delta[1] + j]
      possible_moves << candidate if self.available_square?(candidate, @color)
    end

    possible_moves
  end

end

class Slider < Piece

  DIRECTIONS = {
      :horizontal => [[0, 1], [0, -1]],
      :vertical => [[1, 0], [-1, 0]],
      :diagonal => [[-1, 1], [-1, -1], [1, 1], [1, -1]]
  }
  def possible_moves
    possible_moves = []

    self.move_deltas.each do |delta_i, delta_j|
      candidate = @position

      loop do
        candidate = [candidate[0] + delta_i, candidate[1] + delta_j]
        possible_moves << candidate if self.available_square?(candidate, @color)

        break unless @board.on_board?(*candidate) && @board.empty?(*candidate)
      end
    end

    possible_moves
  end
end

class Rook < Slider
  def move_deltas
    DIRECTIONS[:horizontal] + DIRECTIONS[:vertical]
  end

  def to_s
    (@color == :white) ? "\u2656" : "\u265C"
  end
end

class Bishop < Slider
  def move_deltas
    DIRECTIONS[:diagonal]
  end

  def to_s
    (@color == :white) ? "\u2657" : "\u265D"
  end
end

class Queen < Slider
  def move_deltas
    DIRECTIONS[:horizontal] + DIRECTIONS[:vertical] + DIRECTIONS[:diagonal]
  end

  def to_s
    (@color == :white) ? "\u2655" : "\u265B"
  end
end

class Pawn < Stepper
  def dir
    (@color == :white) ? -1 : 1
  end

  def possible_moves
    forward_moves + attack_positions
  end

  def forward_moves
    forward_moves =[]
    i, j = @position

    if @board.empty?(i + dir, j)
      forward_moves << [i + dir, j]
    end

    # Move forward two. Circle back.
    # if @board.empty?(i + dir, j) &&
#       @board.empty?(i + dir * 2, j) &&
#       at_starting_position?
#         forward_moves << [i + dir * 2, j]
#     end

    forward_moves
  end

  def at_starting_position?
    i, j = @position
    (@color == :white) ? i == 6 : i == 1
  end

  def attack_positions
    i, j = @position
    attack_positions = [
      [i + self.dir, j + 1],
      [i + self.dir, j - 1]
    ]

    attack_positions.reject do |position|
      @board[*position].nil? || @board[*position].color == @color
    end
 end

  def to_s
    (@color == :white) ? "\u2659" : "\u265F"
  end
end # END PAWN


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

  def to_s
    (@color == :white) ? "\u2654" : "\u265A"
  end
end # END KING

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

  def to_s
    (@color == :white) ? "\u2658" : "\u265E"
  end
end
