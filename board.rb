load "./piece.rb"
require "./exceptions"


class Board
  PIECES = {
    "R" => Rook,
    "H" => Knight,
    "B" => Bishop,
    "Q" => Queen,
    "K" => King,
    "P" => Pawn
  }

  def initialize
    @rows = Array.new(8) { Array.new(8) { nil } }
  end

  def self.default_board
    board = Board.new
    board.set_pieces
    board
  end

  def [](i, j)
    @rows[i][j]
  end

  def []=(i, j, piece)
    @rows[i][j] = piece
    piece.position = [i, j] unless piece.nil?
  end

  def check?(color)
    opposing_moves = team_possible_moves(opposite_color(color))
    opposing_moves.include?(king_position(color))
  end

  def checkmate?(color)
    check?(color) && team_legal_moves(color).empty?
  end

  def dup
    dupped_board = Board.new
    all_pieces.each do |piece|
      dupped_board[*piece.position] = piece.dup
    end

    dupped_board
  end

  def empty?(i, j)
    raise IndexError "Off Board!" unless on_board?(i, j)
    self[i, j].nil?
  end

  def move(origin, destination)
    origin = translate_location(origin)
    destination = translate_location(destination)

    piece = self[*origin]

    if piece.legal_moves.include?(destination)
      move!(origin, destination)
    else
      raise IllegalMoveError.new("Make a legal chess move.")
    end
  end

  def move!(origin, destination)

    piece = self[*origin]

    self[*destination] = piece
    self[*origin] = nil
  end

  def on_board?(i, j)
    pos = [i, j]
    pos.all? { |el| el.between?(0, 7) }
  end

  def set_pieces
    power_row = "RHBQKBHR".split("")

    [[0, :black], [7, :white]].each do |row, color|
      power_row.each_with_index do |piece, col|
        self[row, col] = PIECES[piece].new(self, color)
      end
    end

    [[1, :black], [6, :white]].each do |row, color|
      8.times do |col|
        self[row, col] = Pawn.new(self, color)
      end
    end
  end

  def square(square)
    self[*translate_location(square)]
  end

  def to_s
    @rows.each_with_index.map do |row, i|
      row.each_with_index.map do |square, j|
        if square.nil?
          "   "
        else
          " #{square.to_s} "
        end
      end.join("|") + "  #{8 - i}"
    end.join("\n--------------------------------\n") +
    "\n " + ("a".."h").to_a.join("   ")
  end

  def won?
    [:white, :black].any? { |team| checkmate?(team) }
  end

  def over?(color)
    won? || stalemate?(color)
  end

  def stalemate?(color)
    return false if won?
    team_legal_moves(color).empty?
  end

  private

    def all_pieces
      @rows.flatten.compact
    end

    def king_position(color)
      king = team_pieces(color).find { |piece| piece.is_a?(King) }
      king.position
    end

    def opposite_color(color)
      color == :white ? :black : :white
    end

    def team_legal_moves(color)
      team_legal_moves = team_pieces(color).map do |piece|
        piece.legal_moves
      end

      team_legal_moves.flatten(1)
    end

    def team_pieces(color)
      all_pieces.select { |piece| piece.color == color }
    end

    def team_possible_moves(color)
      team_possible_moves = team_pieces(color).map do |piece|
        piece.possible_moves
      end

      team_possible_moves.flatten(1)
    end

    def translate_location(location)
      rows = "87654321"
      cols = "abcdefgh"

      row = rows.split(//).find_index(location[1])
      col = cols.split(//).find_index(location[0])

      unless row && col
        raise IllegalMoveError.new("Enter a move in the format ('a-h'), ('1-8').")
      end

      [row, col]
    end
end
