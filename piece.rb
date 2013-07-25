
class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(board, color)
    @color = color
    @board = board
  end

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
    self.possible_moves.reject { |destination| into_check?(destination) }
  end

  private

  def sum_vectors(vec1, vec2)
    summed_vectors = []

    vec1.each_index do |i|
      summed_vectors << vec1[i] + vec2[i]
    end

    summed_vectors
  end

end #end PIECE

class Stepper < Piece
  def possible_moves
    possible_moves = []

    self.move_deltas.each do |delta|
      candidate = sum_vectors(@position, delta)
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

    self.move_deltas.each do |delta|
      candidate = @position

      loop do
        candidate = sum_vectors(candidate, delta)
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

class Pawn < Piece
  def color_dir
    (@color == :white) ? -1 : 1
  end

  def possible_moves
    (forward_moves + attack_positions).select { |pos| @board.on_board?(*pos) }
  end

  def forward_moves
    forward_moves =[]
    i, j = @position

    if @board.empty?(i + color_dir, j)
      forward_moves << [i + color_dir, j]
    end

    # Move forward two. Circle back.
    if @board.empty?(i + color_dir, j) &&
      @board.empty?(i + color_dir * 2, j) &&
      at_starting_position?
        forward_moves << [i + color_dir * 2, j]
    end

    forward_moves
  end

  def at_starting_position?
    i, j = @position
    (@color == :white) ? i == 6 : i == 1
  end

  def attack_positions
    i, j = @position
    attack_positions = [
      [i + self.color_dir, j + 1],
      [i + self.color_dir, j - 1]
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
