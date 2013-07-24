load "./piece.rb"

#TODO: Add #check, #checkmate, #populate_board
class Board
  PIECES = {
    "R" => Rook,
    "H" => Knight,
    "B" => Bishop,
    "Q" => Queen,
    "K" => King,
    "P" => Pawn
  }

  ROWS = {
    8 => 0,
    7 => 1,
    6 => 2,
    5 => 3,
    4 => 4,
    3 => 5,
    2 => 6,
    1 => 7
  }

  COLS = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }

  def initialize
    @rows = Array.new(8) { Array.new(8) { nil } }
    self.set_pieces
  end

  def [](i, j)
    @rows[i][j]
  end

  def all_pieces
    @rows.flatten.compact
  end

  def check?(color)
    opposing_moves = self.team_possible_moves(opposite_color(color))
    opposing_moves.include?(king_position(color))
  end

  def checkmate?(color)
    check?(color) && team_legal_moves(color).empty?
  end

  def dup
    dupped_board = Board.new
    self.all_pieces.each do |piece|
      dupped_board[*piece.position] = piece.dup
    end

    dupped_board
  end

  def empty?(i, j)
    raise IndexError "Off Board!" unless on_board?(i, j)
    !self[i, j].is_a?(Piece)
  end

  def king_position(color)
    king = self.team_pieces(color).find { |piece| piece.is_a?(King) }
    king.position
  end

  def move(origin, destination)
    origin = translate_location(origin)
    destination = translate_location(destination)

    piece = self[*origin]

    if piece.legal_moves.include?(destination)
      move!(origin, destination)
    end
    #TODO: harden code
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

  def opposite_color(color)
    color == :white ? :black : :white
  end

  def translate_location(location)
    row = ROWS[location[1].to_i]
    col = COLS[location[0]]
    p [row, col]
    [row, col]
  end

  def team_legal_moves(color)
    team_legal_moves = team_pieces(color).map do |piece|
      piece.legal_moves
    end

    team_legal_moves.flatten(1)
  end

  def team_pieces(color)
    self.all_pieces.select { |piece| piece.color == color }
  end

  def team_possible_moves(color)
    team_possible_moves = team_pieces(color).map do |piece|
      piece.possible_moves
    end

    team_possible_moves.flatten(1)
  end

  def to_s
    @rows.map do |row|
      row.map do |square|
        if square.nil?
          "   "
        else
          " #{square.to_s} "
        end
      end.join("|")
    end.join("\n--------------------------------\n")
  end

  private

  def []=(i, j, piece)
    @rows[i][j] = piece
    piece.position = [i, j] unless piece.nil?
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
end



